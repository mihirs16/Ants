module Threads ( spawnThreads ) where

import System.Random ( randomRIO )
import Control.Concurrent ( forkIO, threadDelay )
import Control.Concurrent.STM 
    ( 
        TChan, newTChan, 
        readTChan, writeTChan,
        atomically
    )
import Types ( User (..), Message (..) )


-- | simulate user behaviour
simulatedUser :: TChan Message -> [User] -> Int -> IO ()
simulatedUser messageChannel allUsers userId = do
    
    let user = allUsers !! (userId - 1)                     -- get user for userId

    recvUserId <- randomRIO (1, 10) :: IO Int
    let recvUser = allUsers !! (recvUserId - 1)             -- select a random user
    
    if userId == recvUserId                                 -- don't send a message to myself 
        then simulatedUser messageChannel allUsers userId 
    else do
        waitTime <- randomRIO (0, 1) :: IO Float
        threadDelay $ round (waitTime * 1000000)            -- wait for a random interval  

        let newMessageContent = "this message was sent after " ++ show (waitTime * 1000) ++ " ms"
        let newMessage = Message user newMessageContent recvUser

        -- putStrLn $ "from: " ++ username user ++ "\t | to: " ++ username recvUser ++ "\t | interval: " ++ show (waitTime * 1000) ++ " ms"
        atomically $ writeTChan messageChannel newMessage   -- push a new message in the channel
        simulatedUser messageChannel allUsers userId
                    

-- | spawn threads for a given list of users
spawnThreads :: [User] -> IO [Message]
spawnThreads users = do
    messageChannel <- atomically $ newTChan

    -- spawn a thread for each user
    let n = length users
    _ <- mapM_ (\userId -> forkIO $ simulatedUser messageChannel users userId) [1.. n]

    -- wait for 100 messages in the channel
    mapM (const $ atomically $ readTChan messageChannel) [1::Int ..100]