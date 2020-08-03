module Main where

import Prelude

import Components (header, headerHtml, headerTitleHtml, clickCounter, contentHtml, refreshHtml, decorations, unicorns, renderTotalClicks, refreshDebugHtml)
import Control.Monad.Reader (Reader, ask, runReader)
import Data.Date (Date)
import Data.Foldable (foldl)
import Data.Function.Uncurried (runFn0)
import Effect (Effect)
import Effect.Console (log)
import Render (getDate, rerender)
import View (View, cmapView, ofView, pureView, emptyView, runView)
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
  title :: String,
  dispatch :: Action -> Unit
}

headerReader :: forall s. Reader AppEnv (View s)
headerReader = do
  {title} <- ask
  pure $ ofView $ headerTitleHtml title

appHeader :: forall s. Reader AppEnv (View s)
appHeader = map (\v -> map headerHtml v) headerReader

refreshDebugRdr :: forall s. Reader AppEnv (View s)
refreshDebugRdr = do
  {env, lastUpdated, dispatch} <- ask
  pure $ 
    case env of
      Dev -> ofView $ refreshDebugHtml lastUpdated (\event -> dispatch DebugClicked)
      _ -> emptyView

renderClickMe :: Reader AppEnv (View Int)
renderClickMe = do
  {dispatch} <- ask
  pure $ pureView $ \clicks -> clickCounter clicks (\event -> dispatch Clicked)

renderRefresh :: Reader AppEnv (View Date)
renderRefresh = do
  {dispatch} <- ask
  pure $ pureView $ \lastUpdated -> refreshHtml lastUpdated (\event -> dispatch Update)

renderDecorations :: forall s. View s
renderDecorations = pureView $ \state -> decorations <> unicorns

totalClicks :: View Int
totalClicks = pureView renderTotalClicks

children :: Array (Reader AppEnv (View AppState))
children = [
  map (cmapView \state -> state.lastUpdated) renderRefresh,
  map (cmapView \state -> state.clicks) renderClickMe,
  pure renderDecorations,
  pure $ cmapView (\state -> state.totalClicks) totalClicks
]

contentViews :: Reader AppEnv (View AppState)
contentViews = foldl (<>) (pure emptyView) children

content :: Reader AppEnv (View AppState)
content = map (\v -> map contentHtml v) contentViews

wholeApp :: Reader AppEnv (View AppState)
wholeApp = pure emptyView 
  <> pure (ofView header)
  <> content
  <> appHeader 
  <> refreshDebugRdr

appEnv :: AppState -> AppEnv
appEnv state = {
  lastUpdated: runFn0 getDate,
  env: Dev,
  title: "World's Best Purescript App",
  dispatch: \action -> appDispatch action state
}  

main :: AppState -> Unit
main state = rerender $ runView (runReader wholeApp $ appEnv state) state
--main state = rerender $ bindedView "a"

appDispatch :: Action -> AppState -> Unit -- use State monad instead of passing in state?
appDispatch Clicked state = main $ state { clicks = state.clicks + 1, totalClicks = state.totalClicks + 1 }
appDispatch Update state = main $ state { lastUpdated = (runFn0 getDate), totalClicks = state.totalClicks + 1 }
appDispatch DebugClicked state = main state 
