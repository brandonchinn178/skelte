-- Desugaring of counter.hsml

{-# LANGUAGE RecordWildCards #-}

import Component

data Props = Props
  { name :: String
  }

component :: Component Props Html
component Props{..} children = do
  -- render
  pure $ do
    Blaze.p [] $ do
      Blaze.text "My name is "
      render name
    children
