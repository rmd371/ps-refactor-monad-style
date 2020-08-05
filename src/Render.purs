module Render (rerender, consoleLog) where

import Prelude

import DocumentFragment (DocumentFragment)
import Effect (Effect)

--import Web.DOM (DocumentFragment)

foreign import rerender :: DocumentFragment -> Effect Unit
foreign import consoleLog :: forall a. a -> a
