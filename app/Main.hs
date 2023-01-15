module Main (main) where

import System.IO ( hSetBuffering, stdout, BufferMode(NoBuffering) )
import Behaviour ( birth )
import Threads ( spawnThreads )
import Stats ( generalStats )

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    writeFile "messages.txt" ""             -- create or clean messages.txt
    
    let users = map (birth) [1..10]         -- create 10 users
    spawnThreads users                      -- spawn threads for all users

    generalStats users                      -- stats after completion