module Stats ( generalStats ) where

import Types ( Message (..), User (..) )
import Behaviour ( readMsgsFromTxt )

-- | get the number of messages sent by each user
getMessagesSentByEachUser :: [Message] -> [User] -> [(String, Int)]
getMessagesSentByEachUser _messages [] = []
getMessagesSentByEachUser messages (user:users) = do
    let messagesForUser = filter (\x -> (user_id $ from x) == (user_id user)) messages
    let numMessages = length messagesForUser
    (username user, numMessages):(getMessagesSentByEachUser messages users)


-- | get the number of messages received by each user
getMessagesSentToEachUser :: [Message] -> [User] -> [(String, Int)]
getMessagesSentToEachUser _messages [] = []
getMessagesSentToEachUser messages (user:users) = do
    let messagesForUser = filter (\x -> (user_id $ to x) == (user_id user)) messages
    let numMessages = length messagesForUser
    (username user, numMessages):(getMessagesSentToEachUser messages users)


-- | display the general stats like count of messages
generalStats :: [User] -> IO ()
generalStats users = do
    messages <- readMsgsFromTxt "messages.txt"
    let numOfMessages = length messages
    let numOfMessagesSentByUser = getMessagesSentByEachUser messages users
    let numOfMessagesReceivedByUser = getMessagesSentToEachUser messages users
    
    putStrLn $ "total messages: " ++ show numOfMessages
    putStrLn $ "messages sent: " ++ show numOfMessagesSentByUser
    putStrLn $ "messaged received: " ++ show numOfMessagesReceivedByUser
