-- Generated from Main.skelte

import qualified MyApp.Child as Child

skelte'componentKey :: Skelte'Internal.Key
skelte'componentKey = 124

skelte'component :: Skelte'X.Component ()
skelte'component skelte'anchor _ = do
  skelte'fragment <- Skelte'Internal.templatize skelte'componentKey "<h1>My Page</h1> <!> <!>"

  let testName = "Alice"
  let skelte'node = Skelte'Internal.sibling (Skelte'Internal.firstChild skelte'fragment) 2

  Child.skelte'component skelte'node Child.Skelte'Props
    { name = testName
    , children = Nothing
    }

  let skelte'node1 = Skelte'Internal.sibling skelte'node 2
  Child.skelte'component skelte'node1 Child.Skelte'Props
    { name = "Bill"
    , children = Just $ \skelte'anchor _ -> do
        Skelte'Internal.next
        let skelte'text = Skelte'Internal.text "Some content"
        Skelte'Internal.append skelte'anchor skelte'text
    }

  Skelte'Internal.append skelte'anchor skelte'fragment
