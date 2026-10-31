-- Generated from Counter.skelte

{-# LANGUAGE OverloadedRecordDot #-}

skelte'componentKey :: Skelte'Internal.Key
skelte'componentKey = 987

skelte'component :: Skelte'Internal.Component ()
skelte'component skelte'anchor _ = do
  skelte'fragment <- Skelte'Internal.templatize skelte'componentKey "<input type=\"number\"/> <button class=\"skelte-987\">count</button>"

  count <- Skelte'Internal.state (0 :: Int)
  countDoubled <- Skelte'Internal.derived $ do
    skelte'count <- count.get
    pure $ skelte'count * 2

  let skelte'input = Skelte'Internal.firstChild skelte'fragment
  Skelte'Internal.removeInputDefaults skelte'input
  
  let skelte'button = Skelte'Internal.sibling skelte'input 2

  Skelte'Internal.bindValue skelte'input (Skelte'Internal.get count) (Skelte'Internal.set count)
  Skelte'Internal.delegated "click" skelte'button (count.modify (+ 1))
  Skelte'Internal.append skelte'anchor skelte'fragment
