module Lib
    ( 
        -- spawnThreads
    ) where

import System.IO 
    ( hSetBuffering, 
    stdout, 
    BufferMode(NoBuffering) )
import Control.Concurrent
    ( newChan, 
    readChan, 
    writeChan, 
    forkIO, 
    myThreadId,
    takeMVar,
    putMVar,
    newEmptyMVar,
    MVar,
    Chan )


-- threadedHello :: MVar () -> Chan () -> IO ()
-- threadedHello mutex endFlags = do
--     message <- constructMessage
-- 
--     takeMVar mutex
--     putStrLn message
--     putMVar mutex ()
--     
--     writeChan endFlags ()
-- 
-- spawnThreads :: IO ()
-- spawnThreads = do
--     hSetBuffering stdout NoBuffering
--     let n = 3
--     mutex <- newEmptyMVar
--     endFlags <- newChan
--     _ <- forkIO $ threadedHello mutex endFlags
--     _ <- forkIO $ threadedHello mutex endFlags
--     _ <- forkIO $ threadedHello mutex endFlags
--     putMVar mutex ()
--     mapM_ (\_ -> readChan endFlags) [1::Int ..n]