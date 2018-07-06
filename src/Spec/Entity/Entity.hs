{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Spec.Entity.Entity where

class Entity entity key | entity -> key where
  getID :: entity -> key


