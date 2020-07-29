module Render (rerender, concatFragments, getDate) where

import Prelude

import Data.Date (Date)
import Effect (Effect)
import Web.DOM (DocumentFragment)
import Data.Function.Uncurried (Fn0)

foreign import rerender :: DocumentFragment -> Unit
foreign import concatFragments :: Array DocumentFragment -> DocumentFragment
foreign import getDate :: Fn0 Date
