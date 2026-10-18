module Combinators where

  import Calculator

  --------------------------------------------------------------------------------
  -- Representation: Type aliases for calculator operations.
  -- These aliases make the combinator code a little cleaner.
  --------------------------------------------------------------------------------
  
  -- | A "calculator result" is what we get when a calculator performs an operation.
  --   We define it to be a pair that contains a value and a (new) stack.
  type CalcResult = (Value, Stack)
 
  -- | A "calculator step" is a function that takes a stack, performs some operation, and
  --   returns a calculator result. 
  --   (For example, 'pop' in 'Calculator.hs' is a calculator step.)
  type CalcStep = Stack -> CalcResult 

  --------------------------------------------------------------------------------
  -- CalcStep combinators and CalcResult functions
  --------------------------------------------------------------------------------
 
  -- | Given a calculator step and a function from Value to calculator
  --   step, create a new calculator step that performs the first
  --   step, then calls the provided function on the result.
  followedBy :: CalcStep -> (Value -> CalcStep) -> CalcStep
  followedBy step function stack = 
    let (firstValue, firstStack) = step stack -- run the first step to get a result
    in function firstValue firstStack

  -- | Given two "calculator steps" step1 and step2, create a new
  --   calculator step that performs the first step, then the
  --   second (ignoring the result from the first step).
  thenDo :: CalcStep -> CalcStep -> CalcStep
  thenDo step1 step2 = step1 `followedBy` (\ _ -> step2)

  -- | Given a result and a stack, make a calculator result .
  makeResult :: Value -> Stack -> CalcResult
  makeResult result stack = (result, stack)

