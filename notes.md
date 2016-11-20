- Everything in Elm is function, including things that are called "operations" in JS
  - Elm has various modules (called packages) through which you gain access to key functions, using them much like a method in JS
  - EX: to determine the length of a string, you need to import the String module, then use `String.length "my string"`

- To render text as, import the HTML module and use `Html.text "a string"`
  - This module also provides methods for rendering headers, formatting text etc...
  - A string MUST be passed into to render (i.e. you cannot render numbers, arrays etc... and must convert them using `toString [thing]` first)
- The `main` function is called by default when and Elm file is run in the browser--this is the "entrance" into your app, so if you want your app to do something, somehow `main` needs to be involved
- All variables are CONSTANT --> you cannot update them

**Functions**
- Definition:
```
functionName param1 param2 =
  let
    --code block defining variables
  in
    --code block using variables that returns something (expression)
```
- Use:

```
functionName arg1 arg2`
```
- "Operations": Name must be NON-alphanumeric

```
--Definition
(%/) param1 param2 =
  param1 % param2 == 0

--use
25 %/ 5
--OR
(%/) 25 5
```

*Partial Application*
- Call a function without providing all required params

```
add a b =
  a + b

add3 = add 3

add3 4 --> 7
add3 2 --> 5
```

- Leads to |>

```
add 1 2 |> add 4 --> 7
--this is equivalent to
add (add 1 2) 4
```
*Anonymous Functions*
```
\parm1 param2 -> --body

add 1 2
  |> \a ->
    a % 2 == 0
```

*Composition*
```
newFunc a b = oldFunc1 >> oldFunc2

--equivalent to
newFunc a b =
  oldFunc2 (oldFunc1 a b)

```

**Static Types**
- Once you set a type, it cannot be changed (make sense anyway, since variables are constant and immutable anyway)
- Prevents runtime errors, b/c forces you to make sure you're passing in correct data type etc...
- Some Types in Elm:
  - Primitives
    - String, Char, Float, number, Bool
  - Other
    - Lists (single data type) --> `[]`
    - Tuples (mixed data types) --> `()`
  - Advanced
    - Records --> `rec = {a = 1, b = 2 }`
      - fields MUST exist and cannot be null
      - To update, use `newRec = { rec | a = 3 }`
        - this will create a NEW variable and assign it to the values in rec, with the updated a value
    - Union Types --> WHAT??? Come back to this later
