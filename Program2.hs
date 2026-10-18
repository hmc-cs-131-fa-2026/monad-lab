module Program2 where

  import Calculator
  import Combinators

  -- | A new operation that uses combinators to double the value
  --
  --   Here, we are demonstrating that we can write new stack operations, without knowing
  --   how the stack is implemented.
  double :: CalcStep
  double = push 2 `thenDo` times  
  --       ^^^^^^^^^^^^^^^^^^^^^
  -- This implementation uses the thenDo combinator.
  -- 
  -- We could also have used the `followedBy` operator, like so:
  --       pop `followedBy` \value -> push (2 * value) 
  -- 
  -- ...which can be written in pointfree style, like so:
  --       pop `followedBy` (push . (2 *))

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
  program :: CalcStep
  program = push 3 `thenDo` 
            push 2 `thenDo`
            plus   `thenDo`
            push 7 `thenDo`
            times  `thenDo`
            double

                       