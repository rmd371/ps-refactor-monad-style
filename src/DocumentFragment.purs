module DocumentFragment (DocumentFragment, concatFragments) where

import Prelude

foreign import concatFragments :: Array DocumentFragment -> DocumentFragment
foreign import emptyHtml :: DocumentFragment

data DocumentFragment = Type

-- allow the operator (<>) to be used to concatenate document fragements by implementing the append function
instance semigroupDocumentFragment :: Semigroup DocumentFragment where
  append df1 df2 = concatFragments [df1, df2]

instance monoidDocumentFragment :: Monoid DocumentFragment where
  mempty = emptyHtml
