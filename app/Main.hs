module Main (main) where

import Behaviour 
    (
        birth,
        constructMessage,
        sendMessage
    )

main :: IO ()
main = do
    let fromUser = birth "mihir_singh"
    let toUser = birth "alisha_khan"
    let newMessage = constructMessage "hello world" fromUser toUser
    sendMessage newMessage