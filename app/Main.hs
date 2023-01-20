module Main (main) where

import System.IO ( hSetBuffering, stdout, BufferMode(NoBuffering) )
import Threads ( spawnThreads )
import Stats ( generalStats )
import Types ( User (..) )

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    
    let users = map (\x -> User x ("user_" ++ show x)) [1..10]      -- create 10 users
    messages <- spawnThreads users                                  -- spawn threads for all users
    print $ length messages

    generalStats users messages                                     -- stats after completion