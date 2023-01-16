module Threads ( spawnThreads ) where

import System.Random ( randomRIO )
import Control.Concurrent
    ( 
        forkIO, threadDelay,
        newQSem, signalQSem,
        newQSemN, signalQSemN,
        waitQSem, waitQSemN,
        QSem, QSemN,
    )
import Types ( User (..), Message (..) )
import Behaviour ( readMsgsFromTxt, saveToTxt ) 


-- | simulate user behaviour
simulatedUser ::  QSem -> QSemN -> [User] -> Int -> IO ()
simulatedUser mutex endFlags allUsers userId = do
    
    let user = allUsers !! (userId - 1)                     -- get user for userId

    recvUserId <- randomRIO (1, 10) :: IO Int
    let recvUser = allUsers !! (recvUserId - 1)             -- select a random user
    
    if userId == recvUserId                                 -- don't send a message to myself 
        then simulatedUser mutex endFlags allUsers userId 
    else do
        waitTime <- randomRIO (0, 1) :: IO Float
        threadDelay $ round (waitTime * 1000000)            -- wait for a random interval  

        let newMessageContent = "this message was sent after " ++ show (waitTime * 1000) ++ " ms"
        let newMessage = Message user newMessageContent recvUser

        waitQSem mutex                                      -- acquire lock 
        messages <- readMsgsFromTxt "messages.txt"
        if length messages >= 100 then do
            signalQSem mutex                                -- release lock
            signalQSemN endFlags 1                          -- threads complete
        else do
            putStrLn $ "from: " ++ show user ++ "\t | to: " ++ show recvUser ++ "\t | interval: " ++ show (waitTime * 1000) ++ " ms"
            saveToTxt newMessage "messages.txt"
            signalQSem mutex                                -- release lock
            simulatedUser mutex endFlags allUsers userId    -- repeat this behaviour
                    

-- | spawn threads for a given list of users
spawnThreads :: [User] -> IO ()
spawnThreads users = do
    mutex <- newQSem 0          -- semaphore for locks on I/O
    endFlags <- newQSemN 0      -- semaphore for tracking thread lifecycle

    -- spawn a thread for each user
    let n = length users
    _ <- mapM_ (forkIO . simulatedUser mutex endFlags users) [1.. n]
    signalQSem mutex

    -- wait for all threads to complete
    waitQSemN endFlags (length users)