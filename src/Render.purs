module Render (rerender, getDate, consoleLog) where

import Prelude

import DocumentFragment (DocumentFragment)
import Data.Date (Date)
import Data.Function.Uncurried (Fn0)
import Effect (Effect)

--import Web.DOM (DocumentFragment)

foreign import rerender :: DocumentFragment -> Effect Unit
foreign import getDate :: Fn0 Date
foreign import consoleLog :: forall a. a -> a
