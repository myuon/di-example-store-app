{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
module Spec.Service.StoreService where

import Data.Reflection
import Spec.Dto.ItemDto
import Spec.Entity.ItemEntity

class StoreService a where
  getById :: a -> String -> IO (Maybe ItemEntity)
  getByTag :: a -> String -> IO [ItemEntity]
  list :: a -> IO [ItemEntity]
  create :: a -> ItemDto -> [String] -> IO ()

data SomeStoreService = forall a. StoreService a => SomeStoreService a

instance StoreService SomeStoreService where
  getById (SomeStoreService s) = getById s
  getByTag (SomeStoreService s) = getByTag s
  list (SomeStoreService s) = list s
  create (SomeStoreService s) = create s

type UseStoreService = Given SomeStoreService

useStoreService :: UseStoreService => SomeStoreService
useStoreService = given

