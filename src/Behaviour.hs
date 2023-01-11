module Behaviour 
    ( 
        birth,
        constructMessage,
        sendMessage
    ) where

import Types 
    (
        Message (..),
        User (..)
    )

birth :: String -> User
birth usernameToAssign = do
    let user = User {
        username = usernameToAssign
    }
    user

constructMessage :: String -> User -> User -> Message
constructMessage messageContent fromUser toUser = do
    let message = Message {
        from = fromUser,
        content = messageContent,
        to = toUser
    }
    message

sendMessage :: Message -> IO ()
sendMessage msgToSend = do
    let msgToSave = show msgToSend 
    writeFile "messages.txt" msgToSave

