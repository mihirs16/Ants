module Behaviour 
    ( 
        saveToTxt,
        readMsgsFromTxt,
    ) where

import Types ( Message (..) )


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

