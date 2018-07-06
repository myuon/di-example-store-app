module Impl.Dao.ItemDaoMemoryImpl where

import Spec.Dao.ItemDao
import Spec.Dto.ItemDto
import qualified Data.Map as M
import Data.IORef
import System.IO.Unsafe

data ItemDaoMemoryImpl
  = ItemDaoMemoryImpl (IORef (M.Map String ItemDto))

instance ItemDao ItemDaoMemoryImpl where
  getByID (ItemDaoMemoryImpl ref) name =
    fmap (M.lookup name) $ readIORef ref

  list (ItemDaoMemoryImpl ref) = fmap M.elems $ readIORef ref

  create (repo@(ItemDaoMemoryImpl ref)) dto = do
    uuid <- generateID repo
    let newDto = dto { itemID = uuid }
    modifyIORef ref $ M.insert uuid newDto
    return newDto

newDao :: SomeItemDao
newDao = SomeItemDao $ ItemDaoMemoryImpl $ unsafePerformIO $ newIORef M.empty

newDaoWith :: M.Map String ItemDto -> SomeItemDao
newDaoWith db = SomeItemDao $ ItemDaoMemoryImpl $ unsafePerformIO $ newIORef db

