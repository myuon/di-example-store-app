module Impl.Dao.TagDaoMemoryImpl where

import Spec.Dao.TagDao
import Spec.Dto.TagDto
import qualified Data.Map as M
import Data.IORef
import System.IO.Unsafe

data TagDaoMemoryImpl
  = TagDaoMemoryImpl (IORef (M.Map String TagDto))

instance TagDao TagDaoMemoryImpl where
  getByID (TagDaoMemoryImpl ref) name =
    fmap (M.lookup name) $ readIORef ref

  getByName (TagDaoMemoryImpl ref) name' =
    fmap (\dto -> (\xs -> if null xs then Nothing else Just $ head xs) $ filter (\dto -> name dto == name') $ M.elems dto) $ readIORef ref

  list (TagDaoMemoryImpl ref) = fmap M.elems $ readIORef ref

  create (repo@(TagDaoMemoryImpl ref)) dto = do
    uuid <- generateID repo
    modifyIORef ref $ M.insert uuid $ dto { tagID = uuid }

newDao :: SomeTagDao
newDao = SomeTagDao $ TagDaoMemoryImpl $ unsafePerformIO $ newIORef M.empty

newDaoWith :: M.Map String TagDto -> SomeTagDao
newDaoWith db = SomeTagDao $ TagDaoMemoryImpl $ unsafePerformIO $ newIORef db


