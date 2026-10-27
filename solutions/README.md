# Lab 7 Solutions

Try the lab on your own first. Reading these answers is much less useful than getting stuck and working your way out.

The `.hs` files in this folder are complete, working versions of the starter files. They also include copies of the files they
import, so you can load them from inside this folder:

```
cd solutions
ghci HigherOrderExercises.hs
```

For the open-ended questions ("which would you rather read?"), there's no single right answer. The answers below show the kind
of thing we were hoping you'd notice.

---

## Part 1

### Warmup: `map show`

`map show [1, 2, 3]` is `["1","2","3"]`. Each number becomes a `String`, so the output shows quotation marks. People often
expect `[1,2,3]` back.

`:t map show` gives `Show a => [a] -> [String]`. `map` was given its function but not its list yet, so `map show` is still a
function: it's waiting for a list of showable things, and it will return a list of strings.

### Pointfree style

```haskell
double :: Int -> Int
double = (2 *)
```

### Function composition

```haskell
incrementDouble :: Int -> Int
incrementDouble = double . increment
```

`increment` runs first, because `g . f` runs `f` first. `incrementDouble 1` is `double 2`, which is `4`.

```haskell
map (show . (3 *)) [1, 2, 3]      -- ["3","6","9"]
```

### Functors

```haskell
f :: Int -> Maybe Int
f n = fmap double (onlyOdds n)
-- or, pointfree:
f = fmap double . onlyOdds
```

```haskell
map (fmap (show . double)) [Just 1, Just 2, Just 3]     -- [Just "2",Just "4",Just "6"]
```

There are two layers. `map` goes into the list, then `fmap` goes into each `Maybe`. `fmap (show . double)` is a function from
`Maybe Int` to `Maybe String`.

### Where composition breaks

1. `minNum . maxNum` is a type error. `maxNum` returns a `Maybe Int`, but `minNum` expects a plain `Int`. GHC reports that it
   can't match `Maybe Int` with `Int`.
2. `fmap minNum . maxNum` has type `Int -> Maybe (Maybe Int)`, and on `5` it gives `Just (Just 5)`. `fmap` applies `minNum`
   inside the `Maybe` from `maxNum`, but `minNum` returns its own `Maybe`, so the result ends up wrapped twice. We want one
   `Maybe Int`, and we want a `Nothing` from either step to make the whole result `Nothing`.

### Bind: `numLimits`

```haskell
numLimits :: Int -> Maybe Int
numLimits n = maxNum n >>= minNum
-- minNum n >>= maxNum also works
```

```
ghci> map numLimits [-1..1]
[Nothing,Just 0,Just 1]
ghci> map numLimits [99..101]
[Just 99,Just 100,Just 100]
```

`>>=` takes the `Maybe` from the first function. If it's `Just v`, it calls the second function on `v` and returns that
function's `Maybe` as is, with no extra wrapping. If it's `Nothing`, the whole thing is `Nothing`.

---

## Part 2

### Break `Program1.hs`

1. It still compiles. `run program` returns `(28.0,[28.0,3.0])` instead of `(70.0,[70.0])`. Using `stack2` skips the `plus`
   step: `push 7` goes onto `[2, 3]`, `times` gives `14`, and `double` gives `28`, with the leftover `3` still on the stack.
2. Every stack has the same type, `[Value]`, so the type checker can't tell `stack2` from `stack3`. Using the wrong one is a
   logic error, not a type error.

### Is there a better way?

1. `step` is `pop`. On `[3, 4]`, `pop` gives `firstValue = 3` and `firstStack = [4]`. Then `followedBy` calls `push 3 [4]`,
   which gives `(3.0,[3.0,4.0])`. Popping a value and pushing it back leaves the stack the same as before.
2. The intermediate stacks are gone from `Program2.hs`. `followedBy` (through `thenDo`) passes each step's stack to the next
   step, so the programmer never names a stack. There's no `stack2` to pick by mistake, so you can't make the same bug.
3. Using only calculator operations:

    ```haskell
    tnpo :: CalcStep
    tnpo = push 3 `thenDo`
           times  `thenDo`
           push 1 `thenDo`
           plus
    ```

    Then add `` `thenDo` tnpo `` to the end of `program`. `run program` gives `(211.0,[211.0])`, since `3 * 70 + 1 = 211`.
    You can also write it with Haskell arithmetic as ``pop `followedBy` (\n -> push (3 * n + 1))``.

### Monadic calculators

1. `m` is `CalcStep`, and `a` and `b` are both `Value`. With those choices, `(>>=)` has exactly the type of `followedBy`. The
   body of `>>=` in the `Monad CalcStep` instance does the same thing as `followedBy`: run the first step on the stack, then
   pass its value and new stack to the next function. The only difference is that `CalcStep` is now a `newtype`, so the
   instance has to unwrap the `CalcStep` constructor before running a step and wrap the result back up. Also, the monadic
   version works for any result type `a`, not just `Value`.
2. In `Program3.hs`, `program` is a plain list of steps in a `do` block, just like the numbered list in its comment. The
   `do`-notation `binaryOperation` reads like the pseudocode from earlier (`right <- pop`, `left <- pop`, `push ...`), and
   it has no stack variables at all. Most people find the `do` version easier to read and change. The cost is that you
   have to understand what `>>=` is doing behind the scenes, which is what this lab was for.

### Optional: `tnpo` in `Program3.hs`

```haskell
tnpo :: CalcStep Value
tnpo = do push 3
          times
          push 1
          plus
```

Add `tnpo` as the last line of `program`'s `do` block. `run program` gives `(211.0,[211.0])`.
