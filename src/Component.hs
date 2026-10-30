module Component where

type Component props children = props -> children -> IO Html

data NoChildren = NoChildren

class FromNoChildren a where
  fromNoChildren :: NoChildren -> a
instance FromNoChildren NoChildren where
  fromNoChildren _ = NoChildren
instance FromNoChildren Html where
  fromNoChildren _ = pure ()
