{-# LANGUAGE LambdaCase #-}

import Control.Exception (finally)
import Control.Monad
import Data.IORef
import Data.IntMap.Strict qualified as IM
import System.IO.Unsafe (unsafePerformIO)

data Observer = Observer
  { obId :: !Int
  , obRun :: IO ()
  , obDeps :: IORef [IO ()] -- unsubscribe actions
  }

data Signal a = Signal
  { sigVal :: IORef a
  , sigSubs :: IORef (IM.IntMap Observer)
  }

-- global runtime state
{-# NOINLINE currentObs #-}
currentObs :: IORef (Maybe Observer)
currentObs = unsafePerformIO (newIORef Nothing)

{-# NOINLINE pending #-}
pending :: IORef (IM.IntMap Observer) -- keyed by id => ordered
pending = unsafePerformIO (newIORef IM.empty)

{-# NOINLINE flushing #-}
flushing :: IORef Bool
flushing = unsafePerformIO (newIORef False)

{-# NOINLINE idSupply #-}
idSupply :: IORef Int
idSupply = unsafePerformIO (newIORef 0)

fresh :: IO Int
fresh = atomicModifyIORef' idSupply (\n -> (n + 1, n))

signal :: a -> IO (Signal a)
signal a = Signal <$> newIORef a <*> newIORef IM.empty

-- read, subscribing the current observer if there is one
get :: Signal a -> IO a
get s = do
  readIORef currentObs >>= \case
    Nothing -> pure ()
    Just o -> do
      modifyIORef' (sigSubs s) (IM.insert (obId o) o)
      modifyIORef' (obDeps o) (modifyIORef' (sigSubs s) (IM.delete (obId o)) :)
  readIORef (sigVal s)

set :: (Eq a) => Signal a -> a -> IO ()
set s a = do
  old <- readIORef (sigVal s)
  when (old /= a) $ do
    writeIORef (sigVal s) a
    subs <- readIORef (sigSubs s)
    modifyIORef' pending (IM.union subs)
    flush

-- run dirty observers in id order (creation order ≈ topological order)
flush :: IO ()
flush = do
  busy <- readIORef flushing
  unless busy $ do
    writeIORef flushing True
    drain `finally` writeIORef flushing False
 where
  drain =
    readIORef pending >>= \p -> case IM.minViewWithKey p of
      Nothing -> pure ()
      Just ((_, o), rest) -> writeIORef pending rest >> obRun o >> drain

-- re-tracking effect: clears old deps, reruns body, collects new ones
effect :: IO () -> IO ()
effect body = do
  i <- fresh
  deps <- newIORef []
  let obs = Observer i run deps
      run = do
        readIORef deps >>= sequence_
        writeIORef deps []
        prev <- readIORef currentObs
        writeIORef currentObs (Just obs)
        body `finally` writeIORef currentObs prev
  run

-- derived value = signal kept up to date by an effect
derived :: (Eq b) => IO b -> IO (Signal b)
derived f = do
  s <- signal (error "derived: uninitialised")
  effect $
    f >>= \v -> do
      writeIORef (sigVal s) v -- first run: no Eq on thunk
      subs <- readIORef (sigSubs s)
      modifyIORef' pending (IM.union subs)
  pure s

-- batch: suppress flush until the block finishes
batch :: IO a -> IO a
batch act = do
  writeIORef flushing True
  r <- act `finally` writeIORef flushing False
  flush
  pure r