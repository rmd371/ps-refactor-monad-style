module Main where

import Prelude

import Components (header, headerHtml, clickCounter, contentHtml, refreshHtml, decorations, unicorns, renderTotalClicks, refreshDebugHtml)
import Data.Date (Date)
import Effect (Effect)
import Effect.Console (log)
import Render (concatFragments, rerender, getDate)
import Data.Function.Uncurried (runFn0)

--import Text.Smolder.HTML (div, button)
--import Text.Smolder.Markup (text, (#!), on)
--import Text.Smolder.Renderer.String (render)

data Action = Clicked | Update | DebugClicked
type AppState = {
  lastUpdated :: Date,
  clicks :: Int,
  totalClicks :: Int
}

-- clickCounter :: Int -> String
-- clickCounter clicks = "<div>You've clicked " <> (show clicks) <> " times</div><button onclick='dispatch(\"this works\")'>Click Me</button>"
-- clickCounter :: Int -> String
-- clickCounter clicks = (render $ div $ do text ("You've clicked " <> (show clicks) <> " times")) 
--   <> (render $ button #! on "click" (\event -> log "boom!") $ text "boom")

main :: AppState -> Unit
main state = 
  rerender $ concatFragments [ -- TODO: replace nanohtml with halogen or some purescript DOM manipulation library?
    header,
    contentHtml $ concatFragments [ -- TODO: use concat
      refreshHtml state.lastUpdated (\event -> dispatch Update state), -- TODO: don't pass in state
      clickCounter state.clicks (\event -> dispatch Clicked state), -- TODO: don't pass in state
      decorations,
      unicorns,
      renderTotalClicks state.totalClicks
    ],
    refreshDebugHtml state.lastUpdated (\event -> dispatch DebugClicked state), -- TODO: determine dev or prod
    headerHtml "World's best app" -- TODO: pull title from Reader
  ]

dispatch :: Action -> AppState -> Unit -- use State monad instead of passing in state?
dispatch Clicked state = main $ state { clicks = state.clicks + 1, totalClicks = state.totalClicks + 1 }
dispatch Update state = main $ state { lastUpdated = (runFn0 getDate), totalClicks = state.totalClicks + 1 }
dispatch DebugClicked state = main state 

-- main = button #! on "click" (\event -> log "boom!") $ text "boom"
--main = JS.render $ header <> (contentHtml $ decoration <> blinkHtml unicorns <> clickCounter 5)
--main = JS.render $ render $ div $ text "Using smolder!"
