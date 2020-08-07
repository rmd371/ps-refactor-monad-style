module Test.Main where

import Prelude

import Data.JSDate (JSDate, now, parse)
import DocumentFragment (DocumentFragment, toString)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Main (Action(..), AppState, appDispatch)
import Main as Main
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Assertions.String (shouldContain)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

testFragment :: String -> DocumentFragment -> Effect Unit
testFragment str df = (toString df) `shouldContain` str

makeState :: (AppState -> AppState) -> Effect AppState
makeState updateFn = do 
  d <- now
  pure $ updateFn {clicks: 0, totalClicks: 0, lastUpdated: d}

testMain :: String -> (AppState -> AppState) -> Aff Unit
testMain str updateStateFn = do
  d <- liftEffect now
  state <- liftEffect $ makeState updateStateFn
  liftEffect $ Main.main (testFragment str) state

testDispatch :: Action -> (AppState -> AppState) -> Effect JSDate -> (AppState -> Effect Unit) -> Aff Unit
testDispatch action updateStateFn dateM expectFn = do
  d <- liftEffect now
  state <- liftEffect $ makeState updateStateFn
  liftEffect $ appDispatch expectFn dateM action state

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "Markup tests" do
    it "should contain the number of clicks" do
      testMain "You've clicked 2 times" $ _ {clicks = 2}
    it "should contain the number of total clicks" do
      testMain "<div>Total clicks:</div>\n    <div>9</div>" $ _ {totalClicks = 9}
  describe "Action tests" do
    it "should perform the requested action" 
      let initialState = (_ {totalClicks = 50})
      in do 
        testDispatch Clicked initialState now \s -> s.totalClicks `shouldEqual` 51
    it "should set the last updated date" 
      let 
        dateM = parse "2020-08-06"
      in do
        d <- liftEffect dateM
        testDispatch Update identity dateM \s -> s.lastUpdated `shouldEqual` d
