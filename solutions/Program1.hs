module Program1 where

  import Calculator

  -- | A new operation that uses _existing_ stack operations to double the value
  --   on the top of the stack. 
  --
  --   Here, we are demonstrating that we can write new stack operations, without knowing
  --   how the stack is implemented.
  double :: Stack -> (Value, Stack)
  double stack = let (_, stack1) = push 2 stack
                 in times stack1

  -- We could also have written double this way:
  -- double stack = let (topValue, stack1) = pop stack
  --                in push (2 * topValue) stack1

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
  program :: Stack -> (Value, Stack)
  program stack = let (_, stack1) = push 3 stack
                      (_, stack2) = push 2 stack1
                      (_, stack3) = plus stack2
                      (_, stack4) = push 7 stack3
                      (_, stack5) = times stack4
                  in double stack5

                       