{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
module Spec.Plugin.Logger where

import Data.Reflection

class Logger a where
  writeLog :: a -> String -> IO ()

  debug :: a -> String -> IO ()
  debug a str = writeLog a $ "[DEBUG] " ++ str

  info :: a -> String -> IO ()
  info a str = writeLog a $ "[INFO] " ++ str

  warning :: a -> String -> IO ()
  warning a str = writeLog a $ "[WARNING] " ++ str

  err :: a -> String -> IO ()
  err a str = writeLog a $ "[ERROR] " ++ str

data SomeLogger = forall a. Logger a => SomeLogger a

instance Logger SomeLogger where
  writeLog (SomeLogger i) = writeLog i


type UseLogger = Given SomeLogger

useLogger :: UseLogger => SomeLogger
useLogger = given

