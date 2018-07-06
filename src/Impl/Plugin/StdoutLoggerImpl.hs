module Impl.Plugin.StdoutLoggerImpl where

import Spec.Plugin.Logger

data StdoutLoggerImpl = StdoutLoggerImpl

instance Logger StdoutLoggerImpl where
  writeLog _ str = putStrLn str

newLogger :: SomeLogger
newLogger = SomeLogger StdoutLoggerImpl

