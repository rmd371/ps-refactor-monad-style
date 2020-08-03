module Components (headerHtml, headerTitleHtml, clickCounter, contentHtml, refreshHtml, header, decorations, unicorns, renderTotalClicks, refreshDebugHtml, emptyHtml) where

import Prelude

import Data.Date (Date)
import Effect (Effect)

import Render (DocumentFragment)
import Web.Event.Event (Event)

--foreign import data DocumentFragment :: Type

foreign import header :: DocumentFragment
foreign import contentHtml :: DocumentFragment -> DocumentFragment
foreign import headerHtml :: DocumentFragment -> DocumentFragment
foreign import headerTitleHtml :: String -> DocumentFragment
foreign import refreshHtml :: Date -> (Event -> Unit) -> DocumentFragment
foreign import clickCounter :: Int -> (Event -> Unit) -> DocumentFragment
foreign import decorations :: DocumentFragment
foreign import unicorns :: DocumentFragment
foreign import renderTotalClicks :: Int -> DocumentFragment
foreign import refreshDebugHtml :: Date -> (Event -> Unit) -> DocumentFragment
foreign import emptyHtml :: DocumentFragment