module Spec.Dto.ItemTagRelationDto where

data ItemTagRelationDto
  = ItemTagRelationDto
  { id :: String
  , itemID :: String
  , tagID :: String
  }
  deriving (Show)

