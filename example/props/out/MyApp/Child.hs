-- Generated from Child.skelte

{-# LANGUAGE RecordWildCards #-}

data Skelte'Props = Skelte'Props
  { name :: Skelte'Internal.Prop String
  , children :: Skelte'Internal.Prop (Skelte'Internal.Optional (Skelte.Component ()))
  }

skelte'componentKey :: Skelte'Internal.Key
skelte'componentKey = 123

skelte'component :: Skelte'Internal.Component Skelte'Props
skelte'component skelte'anchor Skelte'Props{..} = do
  skelte'fragment <- Skelte'Internal.templatize skelte'componentKey "<p> </p> <!>"

  let skelte'p = Skelte'Internal.firstChild skelte'fragment
  let skelte'text = Skelte'Internal.onlyChild skelte'p
  let skelte'node = Skelte'Internal.sibling skelte'p 2

  Skelte'Internal.snippet skelte'node (Skelte'Internal.fromMaybe Skelte'Internal.noop children)
  Skelte'Internal.templateEffect $ do
    skelte'name <- Skelte'Internal.get name
    Skelte'Internal.setText skelte'text ("My name is " <> Skelte'Internal.renderText skelte'name)
  Skelte'Internal.append skelte'anchor skelte'fragment
 