# Programming Elixir Notes

## Match operator
- `=` is the match operator
  ```shell
  iex> a = 1
  1
  iex> 1 = a
  1
  iex> 2 = a
  ** (MatchError) no match of right hand side value: 1
  iex> list = [1, 2, 3]
  iex> [a, b, c] = list
  iex> a
  1
  iex> b
  2
  iex> c
  3
  iex> list_2 = [1, 2, [3, 4, 5]]
  iex> c
  [3, 4, 5]
  ```
- `_` can be used to ignore unused values
  ```shell
  iex> [1, _, _] = [1, 2, 3]
  [1, 2, 3]
  iex> [1, _, _] = [1, "dog", "cat"]
  [1, "dog", "cat"]
  ```
- Variables bind once per match
  ```shell
  iex> [a, a] = [1, 1]
  [1, 1]
  iex> a
  1
  iex> [b, b] = [1, 2]
  ** (MatchError) no match of right hand side value: [1, 2]
  ```
- Subsequent matches can rebind variable
- Use the pin operator `^` to prevent rebinding (use existing value)
  ```shell
  iex> a = 1
  1
  iex> a = 2
  2
  iex> ^a = 1
  ** (MatchError) no match of right hand side value: 1
  ```

## Basics
- Value types:
  - Arbitrary-sized integers (`1`, `324`, `1000000`, `1_000_000`)
    - Note can be `_`-separated for readability
  - Floating point numbers to about a 16-decimal precision
  - Atoms: constant whose value is its name
    ```shell
    iex>:beef
    :beef
    ```
  - Ranges: `1..3`
- Regular expressions
  - Can be written as `~{exp}` or `~r{exp}opts`
  - The enclosing characters don't have to be `{` & `}` but they
    reduce needing to escape characters like `/`
  - Options:
    |Option|Description|
    ---|---
    `f`|Force pattern to start match at first line of multline string
    `i`|Case-insensitive
    `m`|For multiline strings, `^` & `$` are the start & end of _each_ line; `\A` & `\z` handle start & end of _all_ lines
    `U`|Make greedy matchers (like `*` & `+`) match as little as possible
    `u`|Enable unicode-specific patterns
    `x`|Extended mode; ignore whitespace & comments
- System types
  - PID: reference to a local or remote process
  - Port: resource to read or write to (like a device?)
- Collection types
  - Tuples: ordered collection of values; uses curly braces
    ```shell
    iex>{1, 2}
    {1, 2}
    iex>{:ok, 42, "next"}
    {:ok, 42, "next"}
    iex>{status, count, _} = {:ok, 42, "next"}
    {:ok, 42, "next"}
    iex>status
    :ok
    iex>count
    42
    ```
    - Tuples usually have 2-4 elements; more usually warrants a Map
    - Common for functions to return a `{status, return_value}` tuple
      - Status is an atom of `:ok` if all went well
      - Pattern match `{:ok, pid} = File.open("some_file.txt")`
  - Lists: a linked structure, not an array
    - The `[head | tail]` nature is a core of Elixir
    - List operators:
      ```shell
      iex> [1, 2, 3] ++ [4, 5, 6]
      [1, 2, 3, 4, 5, 6]
      iex> [1, 2, 3, 4] -- [2, 4]
      [1, 3]
      iex> 1 in [1, 2, 3, 4]
      true
      iex> "wombat" in [1, 2, 3, 4]
      false
  - Keyword lists: quick notation for a list of tuples
    ```shell
    [name: "Dave", city: "Dallas", likes: "Elixir"]
    ```
    is the same as
    ```shell
    [{:name, "Dave", {:city, "Dallas"}, {:likes, "Elixir"}]
    ```
  - Maps: collection of key/value pairs
    - Format is `%{ key => value, key => value, ...}`
    - Keys can be any type
      - Atom keys can use the same format as keyword lists
        ```shell
        %{red:0xff0000, green: 0x00ff00, blue: 0x0000ff}
        ```
        is the same as
        ```shell
        %{{:red, 0xff0000}, {:green, 0x00ff00}, {:blue, 0x0000ff}}
        ```
      - Expressions can be used to set keys
        ```shell
        iex> name = "Matt Fehskens"
        "Matt Fehskens"
        iex> %{String.downcase(name) => name}
        %{"matt fehskens" => "Matt Fehskens"}
    - Square-bracket to access a key's value
      ```shell
      iex> states = %{"NJ" => "New Jersey", "CA" => "California"}
      %{"NJ" => "New Jersey", "CA" => "California"}
      iex>states["NJ"]
      "New Jersey"
      iex> states["TX"]
      nil
      iex> response_types = %{{:error, :noent} => :fail, {:error, :busy} => :retry}
       %{{:error, :noent} => :fail, {:error, :busy} => :retry}
       iex> response_types[{:error, :busy}]
       :retry
      ```
    - Dot-notation access for atom values
    ```shell
    iex>colors = %{red:0xff0000, green: 0x00ff00, blue: 0x0000ff}
    %{blue: 255, green: 65280, red: 16711680}}
    iex>colors.red
    16711680
    iex>colors.yellow
    ```
  - Binaries: access bits & bytes
    - Uses `<<` & `>>` as enclosing characters
    - Elixir uses binaries to represent UTF characters
- Date & Times
  - Elixir ships with the `Calendar` module which provides `Date` type
    ```shell
    iex> d1 = Date.new(2018, 12, 25)
    {:ok, ~D[2018-12-25]}
    iex> {:ok, d1} = Date.new(2018, 12, 25)
    {:ok, ~D[2018-12-25]}
    iex> d2 = ~D[2018-12-25]
    ~D[2018-12-25]
    iex> d1 == d2
    true
    iex> Date.day_of_week(d1)
    2
    iex> Date.add(d1, 7)
    ~D[2019-01-01]
    ```
    - Also provides date ranges with `Date.range`
      ```shell
      iex> d1 = ~D[2019-01-01]
      ~D[2019-01-01]
      iex> d2 = ~D[2018-06-30]
      ~D[2018-06-30]
      iex> first_half = Date.range(d1, d2)
      #DateRage<~D[2018-01-01], ~D[2018-06-30]>
      iex> Enum.count(first_half)
      181
      iex> ~D[2018-03-15] in first_half
      true
  - `Calendar` module also provides `Time` type with hour, minutes, seconds,
    and fractions of a second
    - `~T[1:23:45.0] != ~T[1:23:45.00]`
    - Working with `Time` is similar to `Date`
      ```shell
      iex> {:ok, t1} = Time.new(12, 34, 56)
      {:ok, ~T[12:34:56]}
      iex> t2 = ~T[12:34:56.78]
      ~T[12:34:56.78]
      iex> t1 == t2
      false
      iex> Time.add(t1, 3600)
      ~T[13:34:56.000000]
      iex> Time.add(t1, 3600, :millisecond)
      ~T[13:34:59.600000]
      ```
  - Two date-time types `DateTime` & `NaiveDateTime`
    - `DateTime` can have a time zone associated
  - Using a date/time library (like: https://github.com/lau/calendar) is
    a good idea
- Formats
  - Variables are `snake_case`
  - Modules are `PascalCase`
  - Two-space indenting
  - Comments use a hash (`#`)
  - Elixir has a code formatter
- Booleans: `true`, `false`, `nil`
  - Each is actually an alias for an atom (`:true`, `:false`, `:nil`)
  - Any value other than `false` and `nil` are truthy
- Operators
  - Has a strict equality (`===`, `!==`)
  - Standard operators (`==`, `!=`, `>=`, `>`, `<`, `<=`)
  - Comparison ordering is:
    - Number
    - Atom
    - Reference
    - Function
    - Port
    - PID
    - Tuple
    - Map
    - List
    - Binary
  - Boolean operators
    - Must provide `true` or `false`:
      - `and`
      - `or`
      - `not`
    - Relaxed; can take any value
      - `&&`
      - `||`
      - `!`
  - Arithmetic: `+`, `-`, `*`, `/`
    - `div`: integer-division that outputs a float
    - `rem`: modulo but retains sign
  - Join
    - `binary1 <> binary2`: concat binaries
    - `list1 ++ list2`: concat lists
    - `list1 -- list2`: remove `list2` elements from `list1`
  - `in`: tests that LHS is part of RHS
    - RHS should be an enum (map, list, tuple)
- Variable scope
  - Lexically scope
  - Instead of braces, Elixir uses `do...end`:
    ```elixir
    if (line_no == 50) do
      IO.puts "new-page\f"
      line_no = 0
    end

    IO.puts line_no
    ```
    - This is acutally a "risky" way of writing code, it prefers you
      return the value from the `if` block
- `with` expressions
  - Define local scope for variables
  - Good for temp vars without leaking to a wider scope
  - `<-` in a `with` does pattern matching but if it fails, the value
    that couldn't be matched is returned
  - You can't have a carriage return right after `with`:
    ```elixir
    x = with
          count = Enum.count(my_list),
          # ...
    ```
    should be
    ```elixir
    x = with count = Enum.count(my_list),
          # ...
    ```
    or
    ```elixir
    x = with (
          count = Enum.count(my_list),
          # ...
    ```

# Anonymous Functions

- Basics
  - Anonymous functions take form `var_name = fn ([args]) -> [body] end`
  - Anonymous functions are called with `.` after the variable name, like
   `var_name.([args])`
  - If there are no args, you still need parens: `var_name.()`
  - Function calls are actually pattern-matching, not assigning the
    parameters
- A single function can have multiple bodies see `handle_open.exs`
  - By doing this, the `handle_open` function can gracefully handle
    `File.open` output
  - `:file` is an atom reference to the Erlang `File` module
  - `#{...}` does string interpolation
- Functions can return functions
  ```elixir
  iex> yo = fn -> fn -> "Hello" end end
  #Function<...>
  iex> yo.().()
  "Hello"
  ```
- `&` notation allows for quick helper functions
  ```elixir
  &(&1 + 1)
  ```
  is equivalent to
  ```elixir
  fn (n) -> n + 1 end
  ```
  - `&1` matches the first parameter, `&2` the second, and so on
  - This can be combined with arity on known functions, like:
    ```shell
    iex> a = &length/1
    #Function<...>
    iex> a.([1, 3, 5, 7])
    4
    ```
# Modules & Named Functions

- Named functions _must_ be in modules
- The `do...end` format is syntactical sugar for:
  ```elixir
  def some_fn do: [func_body]
  ```
  - The `do:` format can have multiple lines by using
    parentheses
    ```elixir
    def some_fn do: (
      [func_body]
    )
    ```
- A single function can have many definitions (see `factorial1.exs`)
  - The pattern usually follows a anchor case with 1 or more recursive
    forms that end up calling the anchor case
  - Anchor case has a known answer and/or parameters
  - **Elixir tries forms top-down, so order matters**
    - If you write a form that cannot be reached, Elixir will
      tell you
  - Keep forms of the same function adjacent in a module
- Guard clauses use `when` predicates
  - `when` is evaluated after parameter pattern-matching is done
  - Only accept a subset of Elixir expressions
    - All inequality operators
    - `and, `or`, `not`
    - `||`, `&&`, and `!` are not allowed
    - Join operators `++` & `< >` only if LHS is a literal
    - Typecheck functions (like `is_integer`)
    - `in`
    - Other value-returning functions
      - On page 59 of book
      - Also in the [Getting Started Guide](http://elixir-lang.org/getting-started/case-cond-and-if.html#expressions-in-guard-clauses)
- Default parameters
  - Uses syntax `param // default`
  - Fills in left-to-right, so if params are defined as
    ```elixir
    def my_func(p1, p2 // 2, p3 // 3, p4) do
      ...
    end
    ```
    And 3 parameters are provided, `p3` will still default to `3`
  - Having two same-name functions with different arity will produce an
    error, so
    ```elixir
    def my_func(p1, p2 // 2, p3 // 3, p4) do
      ...
    end

    def my_func(p1, p2) do
      ...
    end
    ```
    Won't work
