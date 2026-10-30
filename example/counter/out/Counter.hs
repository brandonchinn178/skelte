-- Desugaring of counter.hsml

{-# LANGUAGE OverloadedRecordDot #-}

import Component

component :: Component () NoChildren
component _ _ = do
  count <- Lib.signal (0 :: Int)
  countDoubled <- Lib.derived $ (* 2) <$> count.get

  -- render
  count_val <- count.get
  pure $ do
    Blaze.input
      [A.type_ "number", A.class_ "id-123", A.value (render count_val)]
      [A.onValue count.set]
      (pure ())
    Blaze.button
      [A.class_ "id-123"]
      [A.onClick (count.modify (+ 1))]
      (Blaze.text "count")
    Blaze.style "button.id-123 {\n  font-size: 2em;\n}"
