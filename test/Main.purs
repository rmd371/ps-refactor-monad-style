module Test.Main where

import Prelude

import Data.Date (Date, Month(..), canonicalDate)
import Data.Enum (toEnum)
import Data.Maybe (fromJust)
import Data.Time (Time(..))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Class.Console (log, logShow)
import Partial.Unsafe (unsafePartial)

runSample :: forall m. MonadEffect m => m Date -> m Time -> m Unit
runSample dateM timeM = do
  d <- dateM
  t <- timeM
  logShow d
  logShow t

main :: Effect Unit
main = 
  let dateM = pure $ makeDate 2020 August 5
      timeM = pure $ makeTime 10 13 35 0
  in do
    runSample dateM timeM
    log "🍝"
    log "You should add some tests."

makeDate :: Int -> Month -> Int -> Date
makeDate year month day = 
  unsafePartial $ fromJust $ 
    canonicalDate 
      <$> toEnum year 
      <@> month 
      <*> toEnum day

makeTime :: Int -> Int -> Int -> Int -> Time
makeTime hour min sec msec = 
  unsafePartial $ fromJust $ 
    Time 
      <$> toEnum hour 
      <*> toEnum min 
      <*> toEnum sec 
      <*> toEnum msec
