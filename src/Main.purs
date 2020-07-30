module Main where

import Prelude

import Components (header, headerHtml, clickCounter, contentHtml, refreshHtml, decorations, unicorns, renderTotalClicks, refreshDebugHtml, emptyHtml)
import Control.Monad.Reader (Reader, ask, runReader)
import Data.Date (Date)
import Data.Function.Uncurried (runFn0)
import Effect (Effect)
import Effect.Console (log)
import Render (rerender, getDate, DocumentFragment)
--import Web.DOM (DocumentFragment)


--import Text.Smolder.HTML (div, button)
--import Text.Smolder.Markup (text, (#!), on)
--import Text.Smolder.Renderer.String (render)

data Action = Clicked | Update | DebugClicked
type AppState = {
  lastUpdated :: Date,
  clicks :: Int,
  totalClicks :: Int
}

data Env = Prod | Dev
type AppEnv = {
  lastUpdated :: Date,
  env :: Env,
  title :: String
}

-- clickCounter :: Int -> String
-- clickCounter clicks = "<div>You've clicked " <> (show clicks) <> " times</div><button onclick='dispatch(\"this works\")'>Click Me</button>"
-- clickCounter :: Int -> String
-- clickCounter clicks = (render $ div $ do text ("You've clicked " <> (show clicks) <> " times")) 
--   <> (render $ button #! on "click" (\event -> log "boom!") $ text "boom")

headerHtmlRdr :: Reader AppEnv DocumentFragment
headerHtmlRdr = do
  {title} <- ask
  pure $ headerHtml title

refreshDebugRdr :: AppState -> Reader AppEnv DocumentFragment
refreshDebugRdr state = do
  {env, lastUpdated} <- ask
  pure $ 
    case env of
      Dev -> refreshDebugHtml lastUpdated (\event -> dispatch DebugClicked state)
      _ -> emptyHtml

contentRdr :: AppState -> Reader AppEnv DocumentFragment
contentRdr state = pure $ 
  contentHtml $ 
    refreshHtml state.lastUpdated (\event -> dispatch Update state) -- TODO: don't pass in state
    <> clickCounter state.clicks (\event -> dispatch Clicked state) -- TODO: don't pass in state
    <> decorations
    <> unicorns
    <> renderTotalClicks state.totalClicks

wholeApp :: AppState -> Reader AppEnv DocumentFragment
wholeApp state = 
  pure header
  <> contentRdr state
  <> refreshDebugRdr state
  <> headerHtmlRdr 

appEnv :: AppEnv
appEnv = {
  lastUpdated: runFn0 getDate,
  env: Dev,
  title: "World's Best Purescript App"
}  

main :: AppState -> Unit
main state = rerender $ runReader (wholeApp state) appEnv

dispatch :: Action -> AppState -> Unit -- use State monad instead of passing in state?
dispatch Clicked state = main $ state { clicks = state.clicks + 1, totalClicks = state.totalClicks + 1 }
dispatch Update state = main $ state { lastUpdated = (runFn0 getDate), totalClicks = state.totalClicks + 1 }
dispatch DebugClicked state = main state 
