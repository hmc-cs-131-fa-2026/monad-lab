module MonadicCalculator where

  import Control.Monad

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

  -- | A "calculator result" is what we get when a calculator performs an operation.
  type CalcResult a = (a, Stack)
 
  -- | A "calculator step" is a function that takes a stack, performs some operation, and
  --   returns a calculator result. 
  newtype CalcStep a = CalcStep (Stack -> CalcResult a)

  ------------------------------------------------------------------------------
  -- Calculators as monads
  ------------------------------------------------------------------------------

  instance Monad CalcStep where
    (CalcStep firstStep) >>= secondFunction = CalcStep f_then_g 
      where f_then_g stack = let (firstValue, firstStack) = firstStep stack
                                 (CalcStep secondStep) = secondFunction firstValue 
                              in secondStep firstStack            

  instance Functor CalcStep where
    fmap = liftM

  instance Applicative CalcStep where
    pure value = CalcStep (\ stack -> (value, stack))
    (<*>) = ap   

  ------------------------------------------------------------------------------
  -- Basic stack operations 
  ------------------------------------------------------------------------------

  -- | Push a value onto the stack, resulting in a pair: the value and the new stack.
  push :: Value -> CalcStep Value
  push value = CalcStep (pushFunction value)
    where pushFunction v s = (v, (v : s))

  -- | Pop a value from the stack, resulting in a pair: the top value on the
  --   stack and the new stack.
  pop :: CalcStep Value
  pop = CalcStep popFunction
    where popFunction (s:s') = (s, s')
          popFunction []     = error "Stack underflow"

  ------------------------------------------------------------------------------
  -- Arithmetic operations 
  ------------------------------------------------------------------------------

  -- | Add two numbers on the stack
  plus :: CalcStep Value
  plus = binaryOperation (+)

  -- | Subtract two numbers on the stack
  minus :: CalcStep Value
  minus = binaryOperation (-)

  -- | Multiply two numbers on the stack
  times :: CalcStep Value
  times = binaryOperation (*)

  -- | Divide two numbers on the stack
  divide :: CalcStep Value
  divide = binaryOperation (/)

  -- | Given a binary operation and a stack: pop the top two values off the
  --   stack, to use as the right operand (top value) and left operand
  --   (2nd-from-top value) of the operation. Then, push the result back on the
  --   stack.
  --
  --   Note that our implementation uses existing calculator operations such
  --   as push and pop, rather than manipulating the stack directly. By using 
  --   these higher-level operations, we are free to one day change how we
  --   represent stacks, without having to change the implementation of binaryOperation.
  binaryOperation :: (Value -> Value -> Value) -> CalcStep Value
  binaryOperation f = do right <- pop
                         left  <- pop 
                         let result = f left right
                         push result
                                    
  ------------------------------------------------------------------------------
  -- Running a program
  ------------------------------------------------------------------------------

  -- | Run a program, starting with an empty stack
  run :: CalcStep Value -> CalcResult Value
  run (CalcStep p) = p emptyStack
