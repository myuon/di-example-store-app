module Spec.Dto.ItemDto where

data ItemDto
  = ItemDto
  { itemID :: String
  , name :: String
  , price :: Int
  }
  deriving (Show)

