module Threads ( spawnThreads ) where


import Control.Concurrent
    ( 
        forkIO, ThreadId,
        newQSem, signalQSem,
        newQSemN, signalQSemN,
        waitQSem, waitQSemN,
        QSem, QSemN
    )
import Types ( User (..) )


-- | simulate user behaviour
simulatedUser :: User -> QSem -> QSemN -> IO ()
simulatedUser user mutex endFlags = do
    waitQSem mutex              -- acquire lock 
    putStrLn $ show user        
    signalQSem mutex            -- release lock

    -- channel to keep track of completed threads
    signalQSemN endFlags 1      


-- | spawn a new thread for a given user
spawnThread :: QSem -> QSemN -> User -> IO ThreadId
spawnThread mutex endFlags user = forkIO $ simulatedUser user mutex endFlags


-- | spawn threads for a given list of users
spawnThreads :: [User] -> IO ()
spawnThreads users = do
    mutex <- newQSem 0          -- semaphore for locks on I/O
    endFlags <- newQSemN 0      -- semaphore for tracking thread lifecycle

    -- spawn a thread for each user
    _ <- mapM_ (spawnThread mutex endFlags) users
    signalQSem mutex

    -- wait for all threads to complete
    waitQSemN endFlags (length users)