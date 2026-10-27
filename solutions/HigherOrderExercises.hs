--------------------------------------------------------------------------------
-- Introduction and Overview
--------------------------------------------------------------------------------

-- SOLUTIONS for Part 1 of Lab 7. The answers to the written questions are
-- in README.md in this folder.


--------------------------------------------------------------------------------
-- Higher-order functions
--------------------------------------------------------------------------------

-- Recall that a higher-order function is just a function that can accept another
-- function as input or that returns another function as output.

-- map is a great example of a higher-order function. Its first argument is a
-- function (which is applied to each element in map's second argument, which is a
-- list). For example:

--   map show [1, 2, 3]

-- try running that^^!


--------------------------------------------------------------------------------
-- Pointfree style
--------------------------------------------------------------------------------

-- The following function definition should look familiar. It is a simple
-- function that takes a number and increments it.

increment :: Int -> Int
increment x = 1 + x

-- In Haskell, we could also define this function like so:

increment' :: Int -> Int
increment' = (1 +)

-- Instead of declaring and using the variable x, we omit it. Note that we have to
-- surround the expression "1 +" with parentheses, which tells Haskell that this
-- expression actually defines a function that takes a number and returns a
-- number (by adding 1 to the input).

-- EXERCISE: Define a double function (which multiplies a number by 2), using
--           pointfree style. Try calling it in ghci (remember to reload this file).

double :: Int -> Int
double = (2 *)


--------------------------------------------------------------------------------
-- Function composition
--------------------------------------------------------------------------------

-- You might wonder about the benefit of pointfree style: Doesn't it make the code
-- less readable? Yes, sometimes, it does. But sometimes it makes the code more
-- readable -- that is, once we are comfortable reading pointfree style.

-- As an example, here is one (non-pointfree) way to define the "plus 2" function,
-- which adds 2 to a number:

plus2 x = increment (increment x)

-- This definition composes two calls to increment. Function composition is such a
-- common operation that Haskell gives us a shortcut with the . operator.


-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- (.) g f x = g (f x)

-- In other words, (.) is an operator that takes two functions g and f, along with
-- an input x. The operator first calls f on x, then passes the result to g.

-- Here is an alternative definition for plus2 that uses (.)

plus2' x = (increment . increment) x

-- And, in pointfree style:

plus2'' = increment . increment

-- EXERCISE: Using the function-composition operator (.) and pointfree style, along
--           with functions we have defined in this file, fill in the definition
--           for the following function, which should first add one to its
--           argument, then double the result. You should be able to call
--           incrementDouble 1 and get the result 4.

incrementDouble :: Int -> Int
incrementDouble = double . increment

-- Function composition and pointfree style are nice for when we need to define
-- anonymous functions to pass to other functions, such as map.

-- EXERCISE: Using function composition, along with map, show, (3 *), and the list
--           [1, 2, 3], write an expession in GHCI that generates the list
--           ["3", "6", "9"].

-- TODO: your expression here

exp1 = map (show . (3 *)) [1,2,3]


--------------------------------------------------------------------------------
-- Functors
--------------------------------------------------------------------------------

-- Mapping a function over a list is powerful. But what if we want to map a
-- function over a different structure, such as a Maybe? That's what functors are for!

-- A functor generalizes the idea of mapping. Instead of map, we use fmap, like so:

just4 = fmap double (Just 2)

-- This expression gives us (Just 4). It works because Maybe is a functor, i.e., a
-- datatype that defines the fmap function.

-- EXERCISE: Given this function definition:

onlyOdds :: Int -> Maybe Int
onlyOdds i = if even i then Nothing else Just i

-- and using 'fmap' and 'double', define a function 'f' that results in
-- Just (2 * n) if n is odd and Nothing if n is even. You can choose
-- whether or not you want to use pointfree style. Remember that you
-- are working with Maybes, not lists! When you are done, your function
-- should behave like so:

--   ghci> f 1
--   Just 2

--   ghci> f 2
--   Nothing

--   ghci> f 3
--   Just 6

--   ghci> f 4
--   Nothing

f :: Int -> Maybe Int
f n = fmap double (onlyOdds n)

-- We could also define f in pointfree style like so:

--  f =  (fmap double) . onlyOdds



-- EXERCISE: Using various combinations of the functions we've defined and
--           discussed in this file, write an expression that transforms the list
--           [Just 1, Just 2, Just 3] to [Just "2", Just "4", Just "6"].

--           (Hint: If you get an error that says something like "Non type-variable
--           argument...", then you're probably trying to map a function f across a
--           list of things that can't be passed to f.)


-- There are many expressions that will do the work we want. Here is one:

exp2 = map (fmap (show . double)) [Just 1, Just 2, Just 3]

--   The subexpression

--       fmap (show . double)

--   creates a function that takes a Maybe and applies (show . double) to it, giving
--   back a new Maybe. Here's how it works with some example values:

--     fmap (show . double) Nothing  =  Nothing
--     fmap (show . double) (Just v) =  Just ( (show . double) v )

--   The entire expression uses "map" to apply the function created by fmap to each
--   of the values in the list [Just 1, Just 2, Just 3].


--------------------------------------------------------------------------------
-- Monads
--------------------------------------------------------------------------------

-- Let's just dip our toes into monads, specifically the bind operator >>=.

-- First, imagine we had the following functions:

-- | minNum n is Just n if n is non-negative; otherwise it's Nothing
minNum :: Int -> Maybe Int
minNum i = if i < 0 then Nothing else Just i

-- | maxNum n is Just n if n is less than 100; otherwise it's Just 100
maxNum :: Int -> Maybe Int
maxNum i = if i < 100 then Just i else Just 100

-- What if we wanted to combine these functions into a single operation, so that
-- any numbers less than 0 are transformed to Nothing and any numbers greater than
-- 100 are capped at 100?

-- Simple function composition (minNum . maxNum) doesn't work because the output of
-- one function doesn't match the input of the other:

--   *Main> numLimits = minNum . maxNum

--   <interactive>:25:22: error:
--       • Couldn't match type ‘Maybe Int’ with ‘Int’
--         Expected type: Int -> Int
--           Actual type: Int -> Maybe Int
--       • In the second argument of ‘(.)’, namely ‘maxNum’
--         In the expression: minNum . maxNum
--         In an equation for ‘numLimits’: numLimits = minNum . maxNum

-- EXERCISE: fmap let us apply a function to a value inside a Maybe, so try
--           this instead:

--             fmap minNum . maxNum

--           It compiles. What is its type (use :t), and what does it give for 5?
--           Why is that still not what we want?

-- Answer: fmap minNum . maxNum :: Int -> Maybe (Maybe Int), and 5 gives
-- Just (Just 5). fmap applies minNum inside the Maybe from maxNum, but minNum
-- returns its own Maybe, so the result is wrapped twice. >>= runs the next
-- function on the value inside and does not add a second layer.

-- Fortunately, a Maybe is also a monad. And monads have the bind operator:

--   (>>=) :: Monad m => m a -> (a -> m b) -> m b

-- EXERCISE: Using minNum, maxNum and >>=, define the function numLimits.
--           You can test the boundaries of numLimits with the expressions
--           map numLimits [-1..1] and map numLimits [99..101]

--                   Just n     if 0 <= n <= 100
--    numLimits n =  Just 100   if n > 100
--                   Nothing    otherwise

numLimits :: Int -> Maybe Int
numLimits n = maxNum n >>= minNum

-- The other order works too:

--   numLimits n = minNum n >>= maxNum

-- Either way, >>= takes the Maybe from the first function, and if it's Just v,
-- calls the second function on v. If it's Nothing, the result is Nothing.
