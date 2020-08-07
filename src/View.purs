module View (View(View), DocumentFragmentView, runView, cmapView, emptyView) where

import Prelude

import Control.Monad.Reader (class MonadAsk)
import DocumentFragment (DocumentFragment)

newtype View s a = View (s -> a)
type DocumentFragmentView s = View s DocumentFragment

-- see Reader for implementations of these functions (they would be the same for both)
derive newtype instance semigroupOp :: Semigroup a ⇒ Semigroup (View s a)
derive newtype instance functorStat3 :: Functor (View s)
derive newtype instance applyReader :: Apply (View s)
derive newtype instance bindReader :: Bind (View s)
derive newtype instance applicativeReader :: Applicative (View e)
instance monadReader :: Monad (View s)
derive newtype instance monadAskView :: MonadAsk e (View e)

-- it doesn't seem the types line up for a cmap instance method since we want to change e and not a
--derive newtype instance contravariantLogger :: Contravariant (View e)
cmapView :: forall s1 s2 a. (s2 -> s1) -> View s1 a -> View s2 a
cmapView adapterFn (View render) = View \state -> render $ adapterFn state

emptyView :: forall s a. Monoid a => View s a
emptyView = pure mempty

runView :: forall s a. View s a -> s -> a
runView (View renderFn) state = renderFn state 
