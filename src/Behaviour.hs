module Behaviour 
    ( 
        birth,
        constructMessage,
        saveToTxt,
        readMsgsFromTxt,
    ) where

import Types ( Message (..), User (..) )


-- | create new user
birth :: Int -> User
birth userIdToAssign =  User {
        user_id = userIdToAssign,
        username = "user_" ++ show userIdToAssign
    }


-- | create a new message
constructMessage :: String -> User -> User -> Message
constructMessage messageContent fromUser toUser = Message {
        from = fromUser,
        content = messageContent,
        to = toUser
    }


-- | save record to txt
saveToTxt :: Show a => a -> FilePath -> IO ()
saveToTxt dataToSave fileName =
    appendFile fileName (show dataToSave ++ "\n")

 
-- | read messages from txt   
readMsgsFromTxt :: FilePath -> IO [Message]
readMsgsFromTxt fileName = do
    rawData <- readFile fileName
    let messages = map (read :: String -> Message) (lines rawData)
    return messages

