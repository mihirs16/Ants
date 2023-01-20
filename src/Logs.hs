module Logs ( startLogService, logEvent, stopLogService ) where

import Data.Time ( getCurrentTime )
import Control.Concurrent ( forkIO )
import Control.Concurrent.STM
    ( 
        TMVar, newEmptyTMVar, 
        putTMVar, takeTMVar, atomically
    )
import Types ( User (..), Event (..), Log (..) )


-- | start the logging service
startLogService :: IO (TMVar Log)
startLogService = do
    logQueue <- atomically $ newEmptyTMVar
    _ <- forkIO $ logService logQueue
    return logQueue


-- | logging service handler
logService :: TMVar Log -> IO ()
logService logQueue = do
    eachLog <- atomically $ takeTMVar logQueue
    case event eachLog of 
        Stop stopMarker -> do
            putStrLn "--- end of logs ---"
            atomically $ putTMVar stopMarker ()
        MessageSent _msg -> do
            putStrLn $ show eachLog
            logService logQueue


-- | stop the logging service
stopLogService :: TMVar Log -> IO ()
stopLogService logQueue = do
    stopMarker <- atomically $ newEmptyTMVar
    currentTime <- getCurrentTime
    atomically $ putTMVar logQueue (Log {
        sourceUser = (User (-1) "system"),
        event = Stop stopMarker,
        timestamp = currentTime
    })
    atomically $ takeTMVar stopMarker


-- | log a new event
logEvent :: TMVar Log -> String -> User -> IO ()
logEvent logQueue messageContent user = do
    currentTime <- getCurrentTime
    atomically $ putTMVar logQueue (Log {
        sourceUser = user,
        event = MessageSent messageContent,
        timestamp = currentTime
    })