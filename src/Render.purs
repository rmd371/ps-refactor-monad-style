module Render (rerender, concatFragments, getDate, DocumentFragment) where

import Prelude

import Data.Date (Date)
import Data.Function.Uncurried (Fn0)
import Effect (Effect)
--import Web.DOM (DocumentFragment)

foreign import rerender :: DocumentFragment -> Unit
foreign import concatFragments :: Array DocumentFragment -> DocumentFragment
foreign import getDate :: Fn0 Date

data DocumentFragment = Type
-- allow the operator (<>) to be used to concatenate document fragements by implementing the append function
instance semigroupDocumentFragment :: Semiring Unit => Semigroup DocumentFragment where
  append df1 df2 = concatFragments [df1, df2]
