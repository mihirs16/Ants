{-# LANGUAGE DeriveGeneric #-}

module Types 
    ( 
        Message (..),
        User (..) 
    ) where

import GHC.Generics ( Generic )


-- | Message content, sender's and receiver's details
data Message = Message {
    from :: User,
    content :: String,
    to :: User
} deriving (Show, Read, Generic)


-- | User details
data User = User {
    user_id :: Int,
    username :: String
} deriving (Show, Read, Generic)

