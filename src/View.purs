module RefactorMonad.View (View(View)) where

import Prelude

import Data.Functor.Contravariant (class Contravariant)
import Render (DocumentFragment, concatFragments)

data View state = View (state -> DocumentFragment)

instance contravariantLogger :: Contravariant View where
  cmap adapterFn (View renderFn) = View \state -> renderFn $ adapterFn state

instance semigroupView :: Semigroup (View r) where
  append (View renderFn1) (View renderFn2) = View \state -> concatFragments [renderFn1 state, renderFn2 state]

-- --View a0 -> (DocumentFragment -> View a0) -> View a0
-- instance bindView :: Bind View where
--   --bind view otherViewFn = View \state -> render $ otherViewFn $ 
--   --bind :: forall s1 s2. View s1 -> (DocumentFragment -> View s2) -> View s2
--   --bind view otherViewFn = \state -> render (otherViewFn (render view state)) state
--   bind (View f) otherViewFn = View \state -> render $ (otherViewFn $ f state) state

render :: forall s. View s -> s -> DocumentFragment
render (View renderFn) state = renderFn state 