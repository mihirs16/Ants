{-# LANGUAGE DeriveGeneric #-}

module Types 
    ( 
        Message (..),
        User (..),
        Event (..),
        Log (..)
    ) where

import Control.Concurrent.STM ( TMVar )
import GHC.Generics ( Generic )
import Data.Time ( UTCTime )


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
} deriving (Eq, Show, Read, Generic)


-- | Event of a log
data Event = MessageSent String | Stop (TMVar ())
    deriving (Eq)    


-- | derive Show for Event
instance Show Event where
    show (MessageSent eventType) = eventType
    show (Stop _stopMarker) = "stopMarker-MVar"


-- | Log type with source, event and timestamp
data Log = Log {
    sourceUser :: User,
    event :: Event,
    timestamp :: UTCTime
} deriving (Show, Generic)