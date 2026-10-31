module Component where

type Component props = Anchor -> props -> IO ()

newtype Anchor = Anchor DOM.Node
