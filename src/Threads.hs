module Threads ( spawnThreads ) where

import System.Random ( randomRIO )
import Control.Concurrent ( forkIO, threadDelay )
import Control.Concurrent.STM 
    ( 
        TChan, newTChan, 
        readTChan, writeTChan,
        TMVar, atomically
    )
import Types ( User (..), Message (..), Log (..) )
import Logs ( startLogService, logEvent, stopLogService )


-- | simulate user behaviour
simulatedUser :: TMVar Log -> TChan Message -> [User] -> Int -> IO ()
simulatedUser logService messageChannel allUsers userId = do
    
    let user = allUsers !! (userId - 1)                     -- get user for userId

    recvUserId <- randomRIO (1, 10) :: IO Int
    let recvUser = allUsers !! (recvUserId - 1)             -- select a random user
    
    if userId == recvUserId                                 -- don't send a message to myself 
        then simulatedUser logService messageChannel allUsers userId 
    else do
        waitTime <- randomRIO (0, 1) :: IO Float
        threadDelay $ round (waitTime * 5000000)            -- wait for a random interval  

        let newMessageContent = "message sent to: " ++ username recvUser ++ " after " ++ show (waitTime * 5000) ++ " ms"
        let newMessage = Message user newMessageContent recvUser

        logEvent logService newMessageContent user          -- log event
        atomically $ writeTChan messageChannel newMessage   -- push a new message in the channel
        simulatedUser logService messageChannel allUsers userId
                    

-- | spawn threads for a given list of users
spawnThreads :: [User] -> IO [Message]
spawnThreads users = do
    -- start a logging service and a message channel
    logService <- startLogService
    messageChannel <- atomically $ newTChan

    -- spawn a thread for each user
    let n = length users
    _ <- mapM_ (\userId -> forkIO $ simulatedUser logService messageChannel users userId) [1.. n]

    -- wait for 100 messages in the channel
    messages <- mapM (const $ atomically $ readTChan messageChannel) [1::Int ..100]
    
    -- stop the logging service
    stopLogService logService
    
    return messages