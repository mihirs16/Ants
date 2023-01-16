module Stats ( generalStats ) where

import Types ( Message (..), User (..) )
import Behaviour ( readMsgsFromTxt )

-- | get the number of messages sent by each user
messagesSent :: [Message] -> [User] -> [(String, Int)]
messagesSent _messages [] = []
messagesSent messages (user:users) = 
    (username user, numMessages):(messagesSent messages users)
    where numMessages = length $ filter (\x -> (user_id $ from x) == (user_id user)) messages


-- | get the number of messages received by each user
messagesReceived :: [Message] -> [User] -> [(String, Int)]
messagesReceived _messages [] = []
messagesReceived messages (user:users) = 
    (username user, numMessages):(messagesReceived messages users)
    where numMessages = length $ filter (\x -> (user_id $ to x) == (user_id user)) messages


-- | display the general stats like count of messages
generalStats :: [User] -> IO ()
generalStats users = do
    messages <- readMsgsFromTxt "messages.txt"
    let numOfMessages = length messages
    let numOfMessagesSent = messagesSent messages users
    let numOfMessagesReceived = messagesReceived messages users
    
    putStrLn $ "---------------------------------"
    putStrLn $ "total messages simulated: " ++ show numOfMessages
    putStrLn $ "messages sent by each user: " ++ show numOfMessagesSent
    putStrLn $ "messaged received by each user: " ++ show numOfMessagesReceived
