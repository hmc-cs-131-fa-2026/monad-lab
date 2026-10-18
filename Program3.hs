module Program3 where

  import MonadicCalculator

  -- | A new operation that uses combinators to double the value
  --
  --   Here, we are demonstrating that we can write new stack operations, without knowing
  --   how the stack is implemented.
  double :: CalcStep Value
  double = push 2 >>= \_ -> times   -- we could also use do notation...

  -- | Given a stack, the program performs the following steps:
  --     1. push 3
  --     2. push 2
  --     3. plus
  --     4. push 7
  --     5. times
  --     6. double
  --  The result should be 70.0, and the top stack value should also be 70.0.
  --
  --  So, if you call 
  --       run program
  --  you should get
  --       (70.0, [70.0])
  program :: CalcStep Value
  program = do push 3
               push 2
               plus  
               push 7
               times 
               double

                       