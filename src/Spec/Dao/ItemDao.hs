{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
module Spec.Dao.ItemDao where

import Data.UUID
import Data.UUID.V4
import Data.Reflection
import Spec.Dto.ItemDto

class ItemDao a where
  getByID :: a -> String -> IO (Maybe ItemDto)
  list :: a -> IO [ItemDto]
  create :: a -> ItemDto -> IO ItemDto

  generateID :: a -> IO String
  generateID _ = fmap toString nextRandom

data SomeItemDao = forall a. ItemDao a => SomeItemDao a

instance ItemDao SomeItemDao where
  getByID (SomeItemDao s) = getByID s
  list (SomeItemDao s) = list s
  create (SomeItemDao s) = create s

type UseItemDao = Given SomeItemDao

useItemDao :: UseItemDao => SomeItemDao
useItemDao = given


