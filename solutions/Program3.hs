module Program3 where

  import MonadicCalculator

  -- | A new operation that uses combinators to double the value
  --
  --   Here, we are demonstrating that we can write new stack operations, without knowing
  --   how the stack is implemented.
  double :: CalcStep Value
  double = push 2 >>= \_ -> times   -- we could also use do notation...

  -- | If n is on the top of the stack, tnpo will cause 3*n + 1 to be on top of the stack.
  tnpo :: CalcStep Value
  tnpo = do push 3
            times 
            push 1
            plus

  -- | Given a stack, the program performs the following steps:
  --     1. push 3
  --     2. push 2
  --     3. plus
  --     4. push 7
  --     5. times
  --     6. double
  --     7. tnpo
  --  The result should be 211.0, and the top stack value should also be 211.0.
  --
  --  So, if you call 
  --       run program
  --  you should get
  --       (211.0, [211.0])
  program :: CalcStep Value
  program = do push 3
               push 2
               plus  
               push 7
               times 
               double
               tnpo

                       