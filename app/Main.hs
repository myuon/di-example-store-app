{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
module Main where

import Data.Reflection
import Data.Time
import qualified Data.Map as M
import Spec.Plugin.Logger (UseLogger)
import Spec.Service.StoreService
import Spec.Dto.ItemDto
import Spec.Dto.TagDto
import Spec.Dto.ItemTagRelationDto
import qualified Impl.Plugin.StdoutLoggerImpl as StdoutLogger
import qualified Impl.Service.StoreServiceImpl as StoreService
import qualified Impl.Dao.ItemDaoMemoryImpl as ItemDaoMemory
import qualified Impl.Dao.TagDaoMemoryImpl as TagDaoMemory
import qualified Impl.Dao.ItemTagRelationDaoMemoryImpl as ItemTagRelationDaoMemory
import Impl.Controller.MainController
import System.IO.Unsafe

mockItemDB :: M.Map String ItemDto
mockItemDB = M.fromList
  [ ("item-1", ItemDto "item-1" "Lean You a Haskell for Great Good!" 3500)
  , ("item-2", ItemDto "item-2" "Kindle Paperwhite" 13280)
  , ("item-3", ItemDto "item-3" "Y-shirt" 1700)
  ]

mockTagDB :: M.Map String TagDto
mockTagDB = M.fromList
  [ ("tag-1", TagDto "tag-1" "computer" (unsafePerformIO getCurrentTime))
  , ("tag-2", TagDto "tag-2" "book" (unsafePerformIO getCurrentTime))
  , ("tag-3", TagDto "tag-3" "haskell" (unsafePerformIO getCurrentTime))
  ]

mockItemTagDB :: M.Map String [String]
mockItemTagDB = M.fromList
  [ ("item-1", ["tag-1", "tag-2", "tag-3"])
  , ("item-2", ["tag-1"])
  , ("item-3", [])
  ]

mockTagItemDB :: M.Map String [String]
mockTagItemDB = M.fromList
  [ ("tag-1", ["item-1", "item-2"])
  , ("tag-2", ["item-1"])
  , ("tag-3", [])
  ]

inject :: ((UseLogger, UseStoreService) => IO ()) -> IO ()
inject m =
  give StdoutLogger.newLogger $

  give (ItemDaoMemory.newDaoWith mockItemDB) $
  give (TagDaoMemory.newDaoWith mockTagDB) $
  give (ItemTagRelationDaoMemory.newDaoWith mockItemTagDB mockTagItemDB) $

  give StoreService.newService $
  m

main :: IO ()
main = inject $ do
  let app = MainController

  getIndex app
  createNewProduct app
  getIndex app
  listByTag app


