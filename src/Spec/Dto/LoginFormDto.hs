module Spec.Dto.LoginFormDto where

data LoginFormDto
  = LoginFormDto
  { userName :: String
  , password :: String
  }
  deriving (Show)

