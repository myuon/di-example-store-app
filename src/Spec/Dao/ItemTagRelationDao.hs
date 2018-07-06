{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
module Spec.Dao.ItemTagRelationDao where

import Data.Reflection
import Spec.Dto.ItemTagRelationDto

class ItemTagRelationDao a where
  getTagIDsByItemID :: a -> String -> IO [String]
  getItemIDsByTagID :: a -> String -> IO [String]
  create :: a -> String -> String -> IO ()

data SomeItemTagRelationDao = forall a. ItemTagRelationDao a => SomeItemTagRelationDao a

instance ItemTagRelationDao SomeItemTagRelationDao where
  getTagIDsByItemID (SomeItemTagRelationDao d) = getTagIDsByItemID d
  getItemIDsByTagID (SomeItemTagRelationDao d) = getItemIDsByTagID d
  create (SomeItemTagRelationDao d) = create d

type UseItemTagRelationDao = Given SomeItemTagRelationDao

useItemTagRelationDao :: UseItemTagRelationDao => SomeItemTagRelationDao
useItemTagRelationDao = given


