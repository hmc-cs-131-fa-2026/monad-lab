module Calculator where

  ------------------------------------------------------------------------------
  -- Representation
  --
  -- The types and values for a calculator
  ------------------------------------------------------------------------------

  -- | The calculator computes values of this type
  type Value = Double

  -- | The calculator uses a stack of values to do its work
  type Stack = [Value]

  -- | A way to represent an empty stack
  emptyStack :: Stack
  emptyStack = []

  ------------------------------------------------------------------------------
  -- Basic stack operations
  ------------------------------------------------------------------------------

  -- | Push a value onto the stack, resulting in a pair: the value and the new stack.
  push :: Value -> Stack -> (Value, Stack)
  push value stack = (value, (value : stack))

  -- | Pop a value from the stack, resulting in a pair: the top value on the
  --   stack and the new stack.
  pop :: Stack -> (Value, Stack)
  pop (s:s') = (s, s')
  pop []     = error "Stack underflow"

  ------------------------------------------------------------------------------
  -- Arithmetic operations
  ------------------------------------------------------------------------------

  -- | Add two numbers on the stack (note that we could also use pointfree style)
  plus :: Stack -> (Value, Stack)
  plus stack = binaryOperation (+) stack

  -- | Subtract two numbers on the stack (note that we could also use pointfree style)
  minus :: Stack -> (Value, Stack)
  minus stack = binaryOperation (-) stack

  -- | Multiply two numbers on the stack (note that we could also use pointfree style)
  times :: Stack -> (Value, Stack)
  times stack = binaryOperation (*) stack

  -- | Divide two numbers on the stack (note that we could also use pointfree style)
  divide :: Stack -> (Value, Stack)
  divide stack = binaryOperation (/) stack

  -- | Given a binary operation and a stack: pop the top two values off the
  --   stack, to use as the right operand (top value) and left operand
  --   (2nd-from-top value) of the operation. Then, push the result back on the
  --   stack. The entire operation results in a pair: the result of the binary
  --   operation and the new stack.
  --
  --   Note that our implementation uses existing calculator operations such
  --   as push and pop, rather than manipulating the stack directly. By using
  --   these higher-level operations, we are free to one day change how we
  --   represent stacks, without having to change the implementation of binaryOperation.
  binaryOperation :: (Value -> Value -> Value) -> Stack -> (Value, Stack)
  binaryOperation f stack = let (right, stack1) = pop stack
                                (left,  stack2) = pop stack1
                                result = f left right
                                (_, stack3) = push result stack2
                            in (result, stack3)

  ------------------------------------------------------------------------------
  -- Running a program
  ------------------------------------------------------------------------------

  -- | Run a program, starting with an empty stack
  run :: (Stack -> (Value, Stack)) -> (Value, Stack)
  run p = p emptyStack
