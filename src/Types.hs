{-# LANGUAGE DeriveGeneric #-}

module Types 
    ( Message (..),
    User (..) ) where

import GHC.Generics ( Generic )


-- | Message content and sender's details
data Message = Message {
    from :: User,
    content :: String,
    to :: User
} deriving (Show, Generic)


-- | User details and list of received messages 
data User = User {
    username :: String
} deriving (Show, Generic)

