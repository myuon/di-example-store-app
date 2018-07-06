module Spec.Dto.TagDto where

import Data.Time

data TagDto
  = TagDto
  { tagID :: String
  , name :: String
  , createdAt :: UTCTime
  }
  deriving (Show)

