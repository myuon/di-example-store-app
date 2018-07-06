{-# LANGUAGE FlexibleContexts #-}
module Impl.Controller.MainController where

import Data.Time
import Spec.Plugin.Logger
import Spec.Dto.LoginFormDto
import Spec.Entity.ItemEntity
import Spec.Dto.ItemDto as ItemDto
import Spec.Dto.TagDto as TagDto
import Spec.Service.StoreService (UseStoreService, useStoreService)
import qualified Spec.Service.StoreService as StoreService
import System.IO.Unsafe

data MainController = MainController

getIndex :: (UseLogger, UseStoreService) => MainController -> IO ()
getIndex ctrl = do
  info useLogger "GET /"

  items <- StoreService.list useStoreService
  info useLogger $ unlines $ fmap (\entity ->
    let item = itemDto entity in
    let tags = tagsDto entity in
    itemID item ++ ":" ++ ItemDto.name item ++ ":" ++ show (price item) ++ ":" ++ show (fmap TagDto.name tags)) items

listByTag :: (UseLogger, UseStoreService) => MainController -> IO ()
listByTag ctrl = do
  info useLogger "GET /tag/computer"

  items <- StoreService.getByTag useStoreService "computer"
  info useLogger $ unlines $ fmap (\entity ->
    let item = itemDto entity in
    let tags = tagsDto entity in
    itemID item ++ ":" ++ ItemDto.name item ++ ":" ++ show (price item) ++ ":" ++ show (fmap TagDto.name tags)) items

createNewProduct :: (UseLogger, UseStoreService) => MainController -> IO ()
createNewProduct ctrl = do
  info useLogger "POST /product/create"
  info useLogger "{name: 'Laptop new model', price: 150000}\n"

  StoreService.create useStoreService (ItemDto "" "Laptop new model" 150000) ["computer"]

