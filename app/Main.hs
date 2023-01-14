module Main (main) where

import System.IO ( hSetBuffering, stdout, BufferMode(NoBuffering) )
import Behaviour ( birth )
import Threads ( spawnThreads )


main :: IO ()
main = do
    hSetBuffering stdout NoBuffering

    -- create 10 users
    let users = map (birth) [1..10]

    -- spawn threads for all users
    spawnThreads users
