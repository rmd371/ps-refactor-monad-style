module View (View(View), cmap, bindedView) where

import Prelude

import Components (emptyHtml)
import Data.Functor.Contravariant (class Contravariant)
import Render (DocumentFragment)

newtype View s a = View (s -> a)

cmap :: forall s1 s2 a. (s2 -> s1) -> View s1 a -> View s2 a
cmap adapterFn (View render) = View \state -> render $ adapterFn state
-- derive newtype instance contravariantLogger :: Contravariant (View s)
-- instance contravariantLogger :: Contravariant (View s) where
--   -- cmap :: forall a b. (b -> a) -> f a -> f b
--   cmap f (View g) = View \state -> g $ f state

-- derive newtype instance semigroupOp :: Semigroup a ⇒ Semigroup (View s a)
instance semigroupView :: Semigroup a => Semigroup (View s a) where
  -- append :: a -> a -> a
  append (View render1) (View render2) = View \state -> render1 state <> render2 state

-- derive newtype instance functorStat3 :: Functor (View s)
instance functorStat3 :: Functor (View s) where
  -- map :: forall a b. (a -> b) -> f a -> f b
  map mapFn (View render) = View \state -> mapFn $ render state

-- derive newtype instance applyView :: Apply (View s)
instance applyView :: Apply (View s) where
  -- apply :: forall a b. f (a -> b) -> f a -> f b
  apply (View f) (View r) = View \s -> f s $ r s

-- derive newtype instance bindView :: Bind (View s)
instance bindView :: Bind (View s) where
  -- bind :: forall a b. m a -> (a -> m b) -> m b
  bind (View render) otherViewFn = View \state -> runView (otherViewFn $ render state) state

runView :: forall s a. View s a -> s -> a
runView (View renderFn) state = renderFn state 

ofView :: forall s a. a -> View s a
ofView a = View \state -> a

emptyView :: forall s. View s DocumentFragment
emptyView = ofView emptyHtml

-- test methods

myview :: View String String
myview = View \s -> s <> "1"

chainFn :: String -> View String String
chainFn str = View \s -> str <> s <> "2"

bindedView :: String -> String
bindedView str = runView (bind myview chainFn) $ str
--bindedView str = runView myview $ str
