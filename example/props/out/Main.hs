-- Desugaring of counter.hsml

import Component

import qualified MyApp.Child as Child

component :: Component () NoChildren
component _ _ = do
  let testName = "Alice"

  -- render
  pure $ do
    Blaze.h1 [] [] (Blaze.text "My page")
    Child.component Child.Props{name = testName} (fromNoChildren NoChildren)
    Child.component Child.Props{name = "Bill"} $ do
      Blaze.text "Some content"
