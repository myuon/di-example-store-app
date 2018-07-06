module Impl.Dao.ItemTagRelationDaoMemoryImpl where

import Spec.Dao.ItemTagRelationDao
import Spec.Dto.ItemTagRelationDto
import qualified Data.Map as M
import Data.IORef
import System.IO.Unsafe

data ItemTagRelationDaoMemoryImpl
  = ItemTagRelationDaoMemoryImpl
  { itemToTags :: IORef (M.Map String [String])
  , tagToItems :: IORef (M.Map String [String])
  }

instance ItemTagRelationDao ItemTagRelationDaoMemoryImpl where
  getTagIDsByItemID (ItemTagRelationDaoMemoryImpl ref _) key = fmap (M.! key) $ readIORef ref

  getItemIDsByTagID (ItemTagRelationDaoMemoryImpl _ ref) key = fmap (M.! key) $ readIORef ref

  create (ItemTagRelationDaoMemoryImpl ref ref') x y = do
    modifyIORef ref $ M.insertWith (++) x [y]
    modifyIORef ref' $ M.insertWith (++) y [x]

newDao :: SomeItemTagRelationDao
newDao = SomeItemTagRelationDao $ ItemTagRelationDaoMemoryImpl
  (unsafePerformIO $ newIORef M.empty)
  (unsafePerformIO $ newIORef M.empty)

newDaoWith :: M.Map String [String] -> M.Map String [String] -> SomeItemTagRelationDao
newDaoWith m m' = SomeItemTagRelationDao $ ItemTagRelationDaoMemoryImpl
  (unsafePerformIO $ newIORef m)
  (unsafePerformIO $ newIORef m')

