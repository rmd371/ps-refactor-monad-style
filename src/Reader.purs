module Reader (Reader(Reader), runReader) where

import Prelude

import Control.Monad.Reader.Class (class MonadAsk)

-- NOTES
-- All reader types could be derived from monad, but are written out for practice and clarity
-- A future branch will probably just use the built in Reader monad and this file will be deleted?

newtype Reader e a = Reader (e -> a)

-- it doesn't seem the types line up for a cmap instance method since we want to change e and not a
-- derive newtype instance contravariantLogger :: Contravariant (Reader e)

-- derive newtype instance semigroupOp :: Semigroup a ⇒ Semigroup (Reader s a)
instance semigroupReader :: Semigroup a => Semigroup (Reader e a) where
  -- append :: a -> a -> a
  append (Reader render1) (Reader render2) = Reader \env -> render1 env <> render2 env

-- derive newtype instance functorStat3 :: Functor (Reader s)
instance functorReader :: Functor (Reader s) where
  -- map :: forall a b. (a -> b) -> f a -> f b
  map mapFn (Reader render) = Reader \env -> mapFn $ render env

-- derive newtype instance applyReader :: Apply (Reader e)
instance applyReader :: Apply (Reader e) where
  -- apply :: forall a b. f (a -> b) -> f a -> f b
  apply (Reader f) (Reader r) = Reader \e -> f e $ r e

-- derive newtype instance bindReader :: Bind (Reader e)
instance bindReader :: Bind (Reader e) where
  -- bind :: forall a b. m a -> (a -> m b) -> m b
  bind (Reader render) otherReaderFn = Reader \env -> runReader (otherReaderFn $ render env) env

instance monadReader :: Monad (Reader e)

-- derive newtype instance monadAskReader :: MonadAsk e (Reader e)
instance askReader :: MonadAsk e (Reader e) where
  -- ask :: forall e a. (e -> a) -> Reader e a
  ask = Reader (\e -> e)

--derive newtype instance applicativeReader :: Apply (Reader e) => Applicative (Reader e)
instance applicativeReader :: Applicative (Reader s) where
  -- pure :: forall a. a -> f a
  pure e = Reader (\_ -> e)

runReader :: forall e a. Reader e a -> e -> a
runReader (Reader renderFn) env = renderFn env 
