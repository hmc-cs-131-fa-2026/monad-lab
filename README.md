# Lab 7: From Higher-Order Functions to Monads

Starter code for Lab 7. The lab page on the course website walks you through it.

- **Part 1** (`HigherOrderExercises.hs`): pointfree style, composition `.`, `fmap`, and `>>=` on `Maybe`.
- **Part 2** (`Calculator.hs`, `Program1.hs`, `Combinators.hs`, `Program2.hs`, `MonadicCalculator.hs`,
  `Program3.hs`): one stack-calculator program written three ways, first passing the stack by hand,
  then with a homemade combinator, then with Haskell's `Monad` and `do` notation.

**Solutions** are in `solutions/`. Give the lab your best shot first, and look at them after the lab or once you've
really run out of ideas.

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
