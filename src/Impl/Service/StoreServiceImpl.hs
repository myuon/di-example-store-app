{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts #-}
module Impl.Service.StoreServiceImpl where

import Control.Monad
import Data.Maybe
import Spec.Service.StoreService as StoreService
import Spec.Entity.ItemEntity
import Spec.Dto.ItemDto
import Spec.Dto.TagDto as TagDto
import Spec.Dao.ItemDao as ItemDao
import Spec.Dao.TagDao as TagDao
import Spec.Dao.ItemTagRelationDao as ItemTagRelationDao
import Spec.Dao.ItemTagRelationDao

data StoreServiceImpl = (UseItemDao, UseTagDao, UseItemTagRelationDao) => StoreServiceImpl

instance StoreService StoreServiceImpl where
  getById StoreServiceImpl itemID = do
    itemDto <- ItemDao.getByID useItemDao itemID
    case itemDto of
      Just item -> fmap Just $ _setTagToEntity item
      Nothing -> return Nothing

  getByTag StoreServiceImpl name' = do
    fmap (filter $ \entity -> name' `elem` fmap TagDto.name (tagsDto entity)) $ StoreService.list StoreServiceImpl

  list StoreServiceImpl = do
    items <- ItemDao.list useItemDao
    mapM _setTagToEntity items

  create StoreServiceImpl item tags = do
    item' <- ItemDao.create useItemDao item
    forM_ tags $ \tag ->
      TagDao.getByName useTagDao tag >>= \r ->
      maybe (return ()) (\dto -> ItemTagRelationDao.create useItemTagRelationDao (itemID item') (tagID dto)) r

_setTagToEntity :: (UseTagDao, UseItemTagRelationDao) => ItemDto -> IO ItemEntity
_setTagToEntity itemDto = do
  tagIDs <- getTagIDsByItemID useItemTagRelationDao (itemID itemDto)
  tagDtos <- mapM (TagDao.getByID useTagDao) tagIDs
  return $ ItemEntity itemDto $ catMaybes tagDtos

newService :: (UseItemDao, UseTagDao, UseItemTagRelationDao) => SomeStoreService
newService = SomeStoreService StoreServiceImpl

