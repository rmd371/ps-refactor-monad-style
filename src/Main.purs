module Main (main, AppState, appDispatch, Action(..)) where

import Prelude

import Components (appDivHtml, header, headerHtml, headerTitleHtml, clickCounter, contentHtml, refreshHtml, decorations, unicorns, renderTotalClicks, refreshDebugHtml)
import Control.Monad.Reader (ReaderT(..), lift, mapReaderT, runReaderT)
import Control.Monad.Reader.Class (ask)
import Data.Foldable (foldl)
import Data.JSDate (JSDate, now)
import DocumentFragment (DocumentFragment)
import Effect (Effect)
import Prelude as DocumentFragment
import View (View(..), DocumentFragmentView, cmapView, runView)

--import Web.DOM (DocumentFragment)

data Action = Clicked | Update | DebugClicked
type AppState = {
  lastUpdated :: JSDate,
  clicks :: Int,
  totalClicks :: Int
}

data Env = Prod | Dev
type AppEnv = {
  lastUpdated :: JSDate,
  env :: Env,
  title :: String,
  dispatch :: Action -> Effect Unit
}

type ReaderView s = ReaderT AppEnv (View s) DocumentFragment
consReaderView :: forall s. (s -> DocumentFragment) -> ReaderView s
consReaderView f = ReaderT \_ -> View f

debugLastUpdated :: ReaderView JSDate
debugLastUpdated = do
  {dispatch} <- ask
  consReaderView \d -> refreshDebugHtml d (\event -> dispatch DebugClicked)

renderClickMe :: ReaderView Int
renderClickMe = do
  {dispatch} <- ask
  lift $ View \clicks -> clickCounter clicks (\event -> dispatch Clicked)

debug :: ReaderView JSDate
debug = do
  {env} <- ask
  case env of
    Prod -> pure DocumentFragment.mempty
    _ -> debugLastUpdated

renderRefresh :: ReaderView JSDate
renderRefresh = do
  {dispatch} <- ask
  consReaderView \lastUpdated -> refreshHtml lastUpdated (\event -> dispatch Update)

renderDecorations :: forall s. DocumentFragmentView s
renderDecorations = View \_ -> decorations <> unicorns

totalClicks :: DocumentFragmentView Int
totalClicks = View renderTotalClicks

children :: Array (ReaderView AppState)
children = [
  mapReaderT (cmapView \state -> state.lastUpdated) renderRefresh,
  mapReaderT (cmapView \state -> state.clicks) renderClickMe,
  lift renderDecorations,
  lift $ totalClicks # cmapView (\state -> state.totalClicks) -- # is $ (Apply) with the arguments flipped
]

contentViews :: ReaderView AppState
contentViews = foldl (<>) (pure DocumentFragment.mempty) children

content :: ReaderView AppState
content = map contentHtml contentViews

headerReader :: forall s. ReaderView s
headerReader = do
  {title} <- ask
  pure $ headerTitleHtml title

appHeader :: forall s. ReaderView s
appHeader = map (\df -> headerHtml df) headerReader

wholeApp :: ReaderView AppState
wholeApp = pure DocumentFragment.mempty
  <> pure header
  <> content
  <> mapReaderT (cmapView \state -> state.lastUpdated) debug
  <> appHeader
  <#> appDivHtml -- <#> is "map flipped"

appEnv :: JSDate -> (Action -> Effect Unit) -> AppEnv
appEnv date dispatch = {
  lastUpdated: date,
  env: Dev,
  title: "World's Best Purescript App",
  dispatch: dispatch --\action -> appDispatch action state
}  

main :: (DocumentFragment -> Effect Unit) -> AppState -> Effect Unit
main render state = 
  let rerender = main render
      dispatch = \action -> appDispatch rerender now action state
  in do
    d <- now
    render $ runView (runReaderT wholeApp $ appEnv d dispatch) state

appDispatch :: (AppState -> Effect Unit) -> Effect JSDate -> Action -> AppState -> Effect Unit
appDispatch rerender _ Clicked state = rerender $ state { clicks = state.clicks + 1, totalClicks = state.totalClicks + 1 }
appDispatch rerender dateM Update state = do
  d <- dateM
  rerender $ state { lastUpdated = d, totalClicks = state.totalClicks + 1 }
appDispatch rerender _ DebugClicked state = rerender state 
