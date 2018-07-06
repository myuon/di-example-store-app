{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
module Spec.Entity.ItemEntity where

import Spec.Dto.ItemDto
import Spec.Dto.TagDto
import Spec.Entity.Entity

data ItemEntity
  = ItemEntity
  { itemDto :: ItemDto
  , tagsDto :: [TagDto]
  }
  deriving Show

instance Entity ItemEntity String where
  getID = itemID . itemDto

