{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
module Spec.Dao.TagDao where

import Data.UUID
import Data.UUID.V4
import Data.Reflection
import Spec.Dto.TagDto

class TagDao a where
  getByID :: a -> String -> IO (Maybe TagDto)
  getByName :: a -> String -> IO (Maybe TagDto)
  list :: a -> IO [TagDto]
  create :: a -> TagDto -> IO ()

  generateID :: a -> IO String
  generateID _ = fmap toString nextRandom

data SomeTagDao = forall a. TagDao a => SomeTagDao a

instance TagDao SomeTagDao where
  getByID (SomeTagDao s) = getByID s
  getByName (SomeTagDao s) = getByName s
  list (SomeTagDao s) = list s
  create (SomeTagDao s) = create s

type UseTagDao = Given SomeTagDao

useTagDao :: UseTagDao => SomeTagDao
useTagDao = given


