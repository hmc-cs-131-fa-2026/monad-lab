# Lab 7: From Higher-Order Functions to Monads

This lab is a staircase. You start somewhere very familiar, passing functions to other functions, and
by the end you're defining your own monad. Each step exists because the step before it hits a wall:
something plain function composition can't express.

- **Part 1** (`HigherOrderExercises.hs`): HOFs → pointfree style → composition `.` → functors `fmap`
  → monads `>>=`.
- **Part 2** (`Calculator.hs`, `Program1.hs`, `Combinators.hs`, `Program2.hs`): one stack-calculator
  program written with hand-threaded state, then with a homemade combinator, `followedBy`.
- **Part 3** (`MonadicCalculator.hs`, `Program3.hs`): the same program using Haskell's `Monad` and
  `do` notation. Spoiler: `followedBy` *is* `>>=`.

**Submitting (Gradescope):** the instructions and questions live in the **Lab 07** assignment on
Gradescope. Work on the files here and type your answers into Gradescope as you go. You don't
submit this repo.

## Setup

On the course server, clone the lab into your home folder and work there:

```
git clone https://github.com/hmc-cs-131-fa-2026/monad-lab.git ~/monad-lab
cd ~/monad-lab
ghci HigherOrderExercises.hs
```

It should load cleanly (`Ok, one module loaded.`). After editing a file, use `:reload` in `ghci`.
