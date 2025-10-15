# Lixir

Lixir is a simple LISP interpreter written in Elixir.

## Usage

To start the REPL, run:

```
elixir lixir.ex
```

This will start the Lixir REPL, and you can start typing LISP expressions.

```
Lixir 0.1.0
Press Ctrl+C to exit
lixir> (+ 1 2)
3
lixir>
```

## Features

### done

*   Basic arithmetic operations (+, -, *, /)
*   Variable definitions with `def`
*   Anonymous functions with `lambda`

### next

For a more complete LISP interpreter, the following constructs are needed:

*   `quote` to prevent evaluation of an expression
*   `atom` to check if an expression is an atom
*   `eq` to check for equality
*   `car` and `cdr` to access the head and tail of a list
*   `cons` to construct a new list
*   `if` for conditional expressions
