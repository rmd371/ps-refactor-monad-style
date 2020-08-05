module Main where

import Prelude

import Components (appDivHtml, header, headerHtml, headerTitleHtml, clickCounter, contentHtml, refreshHtml, decorations, unicorns, renderTotalClicks, refreshDebugHtml)
import Control.Monad.Reader.Class (ask)
import Data.Foldable (foldl)
import Data.JSDate (JSDate, now)
import Effect (Effect)
import Effect.Console (log)
import Reader (Reader, runReader)
import Render (rerender)
import View (View(..), DocumentFragmentView, cmapView, emptyView, runView)

--import Web.DOM (DocumentFragment)


--import Text.Smolder.HTML (div, button)
--import Text.Smolder.Markup (text, (#!), on)
--import Text.Smolder.Renderer.String (render)

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

debugLastUpdated :: Reader AppEnv (DocumentFragmentView JSDate)
debugLastUpdated = do
  {dispatch} <- ask
  pure $ View \d -> refreshDebugHtml d (\event -> dispatch DebugClicked)

renderClickMe :: Reader AppEnv (DocumentFragmentView Int)
renderClickMe = do
  {dispatch} <- ask
  pure $ View \clicks -> clickCounter clicks (\event -> dispatch Clicked)

debug :: Reader AppEnv (DocumentFragmentView JSDate)
debug = do
  {env} <- ask
  case env of
    Prod -> pure emptyView
    _ -> debugLastUpdated

renderRefresh :: Reader AppEnv (DocumentFragmentView JSDate)
renderRefresh = do
  {dispatch} <- ask
  pure $ View \lastUpdated -> refreshHtml lastUpdated (\event -> dispatch Update)

renderDecorations :: forall s. DocumentFragmentView s
renderDecorations = View \_ -> decorations <> unicorns

totalClicks :: DocumentFragmentView Int
totalClicks = View renderTotalClicks

children :: Array (Reader AppEnv (DocumentFragmentView AppState))
children = [
  renderRefresh <#> (cmapView \state -> state.lastUpdated),
  renderClickMe <#> (cmapView \state -> state.clicks) ,
  pure renderDecorations,
  pure $ totalClicks # cmapView (\state -> state.totalClicks) 
]

contentViews :: Reader AppEnv (DocumentFragmentView AppState)
contentViews = foldl (<>) (pure emptyView) children

content :: Reader AppEnv (DocumentFragmentView AppState)
content = map (\v -> map contentHtml v) contentViews

headerReader :: forall s. Reader AppEnv (DocumentFragmentView s)
headerReader = do
  {title} <- ask
  pure $ pure $ headerTitleHtml title

appHeader :: forall s. Reader AppEnv (DocumentFragmentView s)
appHeader = map (\v -> map headerHtml v) headerReader

wholeApp :: Reader AppEnv (DocumentFragmentView AppState)
wholeApp = pure emptyView 
  <> pure (pure header)
  <> content
  <> (debug <#> (cmapView \state -> state.lastUpdated))
  <> appHeader 
  >>= \view -> pure $ view >>= \df -> pure $ appDivHtml df -- >>= is chain or bind

appEnv :: JSDate -> AppState -> AppEnv
appEnv date state = {
  lastUpdated: date,
  env: Dev,
  title: "World's Best Purescript App",
  dispatch: \action -> appDispatch action state
}  

main :: AppState -> Effect Unit
main state = do
  d <- now
  rerender $ runView (runReader wholeApp $ appEnv d state) state

appDispatch :: Action -> AppState -> Effect Unit -- use State monad instead of passing in state?
appDispatch Clicked state = main $ state { clicks = state.clicks + 1, totalClicks = state.totalClicks + 1 }
appDispatch Update state = do
  d <- now
  main $ state { lastUpdated = d, totalClicks = state.totalClicks + 1 }
appDispatch DebugClicked state = main state 
