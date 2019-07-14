# Programming Elixir Notes

## Ch 2: Match operator
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

## Ch 4: Basics
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

# Ch 5: Anonymous Functions
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
# Ch 6: Modules & Named Functions
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
- Private functions (`defp`)
  - Can have multiple heads
  - Cannot have a public head and any private heads
- Pipe operator (`|>`)
  - Chains functions
  - The return value from the previous call is the first param to the
    next function call
  - Function parameters should _always_ be enclosed in parentheses with the
    pipe operator
- Modules
  - Provides namespacing for functions
  - Reference functions in module as `ModuleName.func`
    - If in the same module, don't need to use the module name
  - You can nest modules
    - To call an inner module just prefix it with the outer module
      ```elixir
      defmodule Outer do
        defmodule Inner do
          def inner_func do
          end
        end

        def outer_func do
          inner_func
        end
      end

      Outer.outer_func
      Outer.Inner.inner_func
      ```
    - Nesting is syntactic sugar; Elixir actually puts these all at
      the top-level and prefixes them appropriately; the above becomes:
      ```elixir
      defmodule Outer do
        def outer_func do
          Inner.inner_func
        end
      end

      defmodule Outer.Inner do
        def inner_func do
        end
      end
      ```
- Module directives
  - All lexically scoped
  - `import`: bring a module's code into the current scope so we don't
    have to type the module name out every time
    ```elixir
    import Module
    ```
    - Also has `only` & `except` options
  - `alias`: give a module an alias to cut down on typing
    ```elixir
    alias Some.Module.Here, as: ModuleHere
    ```
  - `require`: ensures any macros in that module are available at
    compilation
  - Attributes: metadata for a module
    - Prefixed with an `@`
    - Can only be declared at the top of a module
    - Attributes can be redeclared
      - The value read by a function is the last value set before
        that function was declared
    - Usually used for declaring constants
- Module names
  - Module names are just atoms
  - Modules are prefixed with `Elixir.` by Elixir, so `IO` is really just
    `:"Elixir.IO"`
  - Erlang modules are referenced as atoms, like `:timer`
    - Functions in modules are called similarly, like `:timer.tc`

# Ch 7: Lists
- List can be empty (`[]`) or be a head & a tail (`[head | tail]`)
  - A single element list can be represent as a head & an empty list
    ```elixir
    [3 | []] # same as [3]
    [2, | [3, []]] # same as [2, 3]
    ```
  - Pattern matching can be done `[head | tail]`:
    ```elixir
    iex> [h | t] = [1, 2, 3]
    [1, 2, 3]
    iex> h
    1
    iex> t
    [2, 3]
    ```
- If all values in a list are printable characters, Elixir will turn them
  into a string:
  ```
  iex> [99, 97, 116]
  'cat'
  ```
- List length
  - Empty list is 0
  - Non-empty is 1 + length of tail
  ```elixir
  defmodule ListCounter do
    def len([]), do: 0
    def len([_ | tail]), do: 1 + len(tail)
  end

  MyList.len([1, 2, 3, 4]) # 4
  MyList.len(["cat", "dog"]) # 2
  ```
- Look at `my-list.exs` to see some list processing examples
- The join operator (`|`) can take multiple values to the left
  ```shell
  iex> [1, 2, 3 | [4, 5, 6]]
  [1, 2, 3, 4, 5, 6]
  ```
- We can also pattern match on entries in a list (see `weather.exs`)
- List module
  - Provides functions for operator on lists
  - `.flatten`: transform a list of nested lists into a single-level list
    ```shell
    iex> List.flatten [[[1], 2], [[[3]]]]
    [1, 2, 3]
    ```
  - `.foldl` & `.foldr`: reduce with direction
    ```shell
    iex> List.foldl [1, 2, 3], "", &("#{&1}(#{&2})")
    "3(2(1()))"
    iex> List.foldr [1, 2, 3], "", &("#{&1}(#{&2})")
    "1(2(3()))"
    ```
  - `.replace_at`: replace at index; this is not a cheap op
    ```shell
    iex> List.replace_at [1, 2, 3], 2, "milk"
    [1, 2, "milk"]
    ```
  - `.keyfind`: find a tuple in a list of tuples
    ```shell
    iex> keylist = [name: "Matt", likes: "JS", where: "NJ"]
    [name: "Matt", likes: "JS", where: "NJ"]
    iex> List.keyfind keylist, "JS", 1
    {:likes, "JS"}
    iex> List.keyfind keylist, "Elixir", 2
    nil
    iex> keylist = [{:name, "Matt"}, {:likes, "JS", "Elixir"}, {:where, "NJ"}]
    [{:name, "Matt"}, {:likes, "JS", "Elixir"}, {:where, "NJ"}]
    iex> List.keyfind keylist, "JS", 1
    {:likes, "JS", "Elixir"}
    iex> List.keyfind keylist, "Elixir", 2
    {:likes, "JS", "Elixir"}
    iex> List.keyfind keylist, "JS", 2
    nil
    ```
  - `.keydelete`: remove tupeles from list of tuples for a key match
    ```shell
    iex> List.keydelete keylist, "Matt", 1
    [{:likes, "JS", "Elixir"}, {:where, "NJ"}]
    ```
  - `.keyreplace`: remove tupeles from list of tuples for a key match
    ```shell
    iex> List.keyreplace keylist, :where, 0, {:where, "Deptford", "NJ"}
    [{:name, "Matt"}, {:likes, "JS", "Elixir"}, {:where, "Deptford", "NJ"}]

# Ch 8: Dictionary Types
- How do you choose between different types...ask these questions (in order):
  #|Question|Type
  ---|---|---
  1.|Pattern match against contents?|Map
  2.|Could it have repeated keys?|`Keyword` module
  3.|Guarantee element order?|`Keyword` module
  4.|Fixed set of fields?|Struct
  5.|Otherwise...|Map
- Keyword lists
  - Normal form:
    ```elixir
    [style: "regular", size: 16, underline: true]
    ```
  - Usually used to pass options to functions
    ```elixir
    Example.func("pizza", style: "bold", size: 12, underline: true)
    ```
  - Values can be accessed by doing `klist[key]`
  - `Keyword` & `Enum` module work with keyword lists
- Maps
  - Go-to dictionary type
  - Good performance at all sizes
  - Example:
    ```shell
    iex> me = %{name: "Matt", age: 34, kids: ["Ben"]}
    %{name: "Matt", age: 34, kids: ["Ben"]}
    ```
  - Using the `Map` module:
    ```shell
    iex> Map.keys me
    [:age, :kids, :name]
    iex> Map.values me
    [34, ["Ben"], "Matt"]
    iex> me.name
    "Matt"
    iex> me_less = Map.drop me, [:age, :kids]
    %{name: "Matt"}
    iex> Map.has_key? me_less, :kids
    false
    iex> me_more = Map.put me, :likes, "Programming"
    %{name: "Matt", age: 34, kids: ["Ben"], likes: "Programming"}
    iex> Map.keys me_more
    [:age, :kids, :likes, :name]
    iex> {value, update_me} = Map.pop me_more, :likes
    {"Programming", %{name: "Matt", age: 34, kids: ["Ben"]}}
    iex> Map.equal? me, updated_me
    true
    iex> Map.equal? me, me_less
    false
    ```
  - Pattern-matching Maps
    - Works like you would think: `%{name: name_var} = my_map`
    - A `MatchError` will raise if a key is attempted to be matched that is not
      in that map
  - Updating a map
    - Uses the join operator: `new_map = %{old_map | key => value, ...}`
      - But this will not add a new key to a map!
    - `Map.put_name` will add a key to a map
- Structs: module that wraps a limited form of a map
  - Think of them as typed maps
    - Fixed set of fields
    - Pattern match by type & content
  - Limits
    - Keys must be atoms
    - Do not have dict capabilities
  - Module name is map type
  - Example:
    ```elixir
    defmodule Subscriber do
      defstruct name: "", paid: false, over_18: true
    end
    ```
  - Instantiate with map-like syntax:
    ```shell
    iex> s1 = %Subscriber{}
    %Subscriber{name: "", paid: false, over_18: true}
    iex> s2 = %Subscriber{name: "Matt", paid: true}
    %Subscriber{name: "Matt", paid: true, over_18: true}
    iex> s2.name
    "Matt"
    iex> %Subscriber{s1 | name: "Sue"}
    %Subscriber{name: "Sue", paid: false, over_18: true}
    ```
  - Structs are wrapped in modules so we can add functionality to them
    ```elixir
    defmodule Subscriber do
      defstruct name: "", paid: false, over_18: true

      def can_vote(subscriber = %Subscriber{}) do
        subscriber.paid && subscriber.over_18
      end

      def print_badge(%Subscriber{name: name}) when name != "" do
        IO.puts "VIP: #{name}"
      end

      def print_badge(%Subscriber{}) do
        IO.puts "Cannot print badge, no name"
      end
    end
    ```
  - Structs can be nested
    - Dot-notation access `my_struct.something.something_child`
    - Updating with join operator are ugly, so Elixir has nested dictionary
      access functions:
      - `put_in` sets the value for a nested key
        ```elixir
        put_in(my_struct.someting.something_child, "Kiddo")
        ```
      - `update_in` sets a value for a nest key using a provided function
        ```elixir
        update_in(my_struct.something.something_child, &("Child: #{&1}"))
        ```
      - `get_in`: gets a nested value
      - `get_and_update_in`: gets a nested value and updates it using a
        provided function
- `Access` module: predefined functions to act as params to `get_in`  and
  `get_and_update_in`
  - For lists:
    - `all`: returns all elements in the list
    - `at`: return element at an index
  - For tuples:
    - `elem`: return element at a tuple index
  - For dictionaries:
    - `key`: get the element at the provided key
  - For map or keyword list:
    - `pop`: remove entry
- Sets: implemented using the `MapSet` module
  ```shell
  iex> set1 = 1..5 |> Enum.into(MapSet.new)
  #MapSet<[1, 2, 3, 4, 5]>
  iex> set2 = 3..8 |> Enum.into(MapSet.new)
  #MapSet<[3, 4, 5, 6, 7, 8>]
  iex> MapSet.member? set1, 3
  true
  iex> MapSet.union set1, set2
  #MapSet<[1, 2, 3, 4, 5, 6, 7, 8]>
  iex> MapSet.difference set1, set2
  #MapSet<[1, 2]>
  iex> MapSet.difference set2, set1
  #MapSet<[6, 7, 8]>
  iex> MapSet.intersection set1, set
  #MapSet<[3, 4, 5]>
  ```

# Ch 9: Aside: What are Types?
- A list, a map, or a keyword list are actual primitives
- The respective modules `List`, `Map`, and `Keyword` provide abstractions
  to working with those primitives
  - A keyword list, for example, can use not only work with the `Keyword`
    module but also the `List`, `Enum`, and `Collectable` modules

# Ch 10: Enum & Stream
- Outside of lists & maps, Elixir has other types that act as collections
  - Ranges
  - Files
  - Functions (?!)
  - Can define own through protocols
- What makes them collections is they can be iterate through them
  - Some also share the ability to add to them
  - Things that can be iterated implement the `Enumerable` protocol
- Two iteration modules
  - `Enum`: is the primary iteration module
  - `Stream`: like `Enum`, but processes lazily
- `Enum`
  - Use it to iterate, filter, combine, split, & manipulate collections
  - `to_list <collection>`: convert a collection to a list
  - `concat <collection_1>, <collection_2>, ...`: combine collections together
  - `map <collection>, <func>`: create a list with entries as a function of
    their original value
  - Get item at position or by key or some criteria:
    - `at <collection>, <index/key>`: get element of collection at index or of
      the given key
    - `filter <collection>, <func>`: get entries where `func` returns `true`
    - `reject <collection>, <func>`: get entries where `func` returns `false`
  - `sort <collection>[, <func>]`: sort a list using an (optional) function
    - NOTE: use `<=` (instead of `<`) to ensure a stable sort
  - Get maximum value
    - `max <collection>`: get the greatest value
    - `max_by <collection>, <func>`: get the greatest value, using `func`
      to perform comparison
  - Take functions
    - `take <collection>, <number>`: grab the first `number` items of the
      collection
    - `take_every <collection>, <number>`: grab each `number` element of the
      collection
    - `take_while <collection>, <func>`: grab items while `func` returns `true`
  - Splitting a list
    - `split <collection>, <index>`: split the collection at the given `index`
    - `split_while <collection>, <func>`: split a collection, putting items into
      the first partition until `func` returns false
  - Predicate functions
    - `all? <collection>, <func>`: do all elements of the `collection` pass
      `func`?
    - `any? <collection>, <func>`: does any element of the `collection` pass
      `func`?
    - `member? <collection>, <value>`: is `value` a member of `collection`?
    - `empty? <collection>`: is the `collection` empty?
  - List combining
    - `zip <collection_1>, <collection_2>, ...`: combine items at the same
      position of each collection into a tuple
    - `with_index <collection>`: transform each entry into a tuple of
      `{<index>, <value>}`
  - Get a single value from a collection:
    - `reduce <collection>[, <initial>], <func>`: get a single value that
      accumulates using the `func`; `initial` is inferred if not provided
    - `join <collection>[, <separator>]`: join a list into a string by an
      (optional) character
- Streams: like `Enum`, but only runs steps as needed
  - Stream functions return a specification of what is intended, sort of like
    JavaScript Promises:
    ```shell
    iex> s = Stream.map [1, 3, 5, 7], &(&1 + 1)
    #Stream<[enum: [1, 3, 5, 7], funs: [#Function<49.126435914/1 in Stream.map/2>]]>
    ```
  - To get the actual result, pass them to `Enum.to_list`
    ```shell
    iex> Enum.to_list s
    [2, 4, 6, 8]
    ```
  - Streams can also be passed to other `Stream` functions
  - Since streams are lazy, we don't always need to produce all results to get
    to the next step in a chain:
    ```shell
    iex> Stream.map(1..10_000_000, &(&1 + 1)) |> Enum.take(5)
    [2, 3, 4, 5, 6]
    ```
    - If we use `Enum.map/2`, it takes a few seconds; using the stream gets
      a result immediately
  - Streams can run on infinitely, processing as data becomes available
  - Creating streams
    - The Stream implementation is very complex
    - Wrapper functions help abstract away low-level details
  - `Stream.cycle <enumerable>`: take an enumerable and return an infinite
    stream that runs through the enumerable's items and starts over after
    all items are processed
    ```shell
    iex> Stream.cycle(~w(green white})) |>
    ...> Stream.zip(1..5) |>
    ...> Enum.to_list
    [{"green", 1}, {"white", 2}, {"green", 3}, {"white", 4}, {"green", 5}]
    ```
  - `Stream.repeatedly <func>`: invoke the provided function each time a new
    value is wanted
    ```shell
    iex> Stream.repeatedly(fn -> true end) |> Enum.take(3)
    [true, true, true]
    ```
  - `Stream.iterate <start_value>, <next_func>`: returns infinite stream where
    the first value returned is `start_value`, the next value is `next_func`
    applied to `start_value`, third is `next_func` applied to the 2nd value,
    and so on
    ```shell
    iex> Stream.iterate(0, &(&1 + 2)) |> Enum.take(6)
    [0, 2, 4, 6, 8, 10]
    ```
  - `Stream.unfold <func>` is like `.iterate` but the `func` must return a
    tuple containing two values: the return value from this iteration and the
    argument to be passed to the next iteration. If the next argument is `nil`,
    the stream ends
    ```shell
    iex> Stream.unfold(1, fn n -> {n, n * 2} end) |> Enum.take(15)
    [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
    ```
  - `Stream.resource <start_func>, <process_func>, <end_func>`: like `unfold`
    but the initial value is computed by `start_func`. The `process_func` works
    like `iterate`'s function. And the `end_func` runs at the end of
    enumeration
    - For an example see `countdown.exs`
      - This example shows how lazy Streams can deal with async resources
        without side effects (since the functions are initialized as they) are
        used
      - When the stream is piped to an Enum function, that's when the values
        are computed
- Collectable Protocol & Comprehensions
  - Allows building of a collection by inserting in to it
  - Usually accessed via `Enum.into` + comprehensions
  - Streams are collectable
  - Comprehensions make the map & filter of collections easier
  - Comprehensions:
    - Take 1 or more collections
    - Extract all combinations of values from each
    - (Optional) Filter values
    - Generates a new collection with remaining values
  - Comprehension syntax:
    ```elixir
    result = for <generator or filter>...[, into: value], do: expression
    ```
  - Basic comprehension examples:
    ```shell
    iex> for x <- [1, 2, 3, 4, 5], do: x * x
    [1, 4, 9, 16, 25]
    iex> for x <- [1, 2, 3, 4, 5], x < 4, do: x * x
    [1, 4, 9]
    ```
  - You can declare multiple variables with multiple inputs:
    ```shell
    iex> for x <- [1, 2], y <- [5, 6], do: x + y
    [6, 7, 7, 8]
    ```
  - Variables from earlier generators can be used in later generatros:
    ```shell
    iex> min_maxes = [{1,4}, {2,3}, {10, 15}]
    [{1, 4}, {2, 3}, {10, 15}]
    iex> for {min,max} <- min_maxes, n <- min..max, do: n
    [1, 2, 3, 4, 2, 3, 10, 11, 12, 13, 14, 15]
    ```
  - Filters gatekeep: if the condition isn't met, it moves on to the next
    entry in the collection
    - There can be multiple filters, like there are multiple generators
  - Comprehensions can have deconstructions
    ```shell
    iex> for {city, state} <- cities, do: {state, city}
    ```
  - Comprehensions can work on bits
    ```shell
    iex> for <<  ch <- "hello" >>, do: <<ch>>
    ["h", "e", "l", "l", "o"]
    ```
  - Variables in a comprehension are local and do not overwrite external
    variables:
    ```shell
    iex> name = "Matt"
    "Matt"
    iex> for name <- ["Sue", "Ben"], do: String.upcase(name)
    ["SUE", "BEN"]
    iex> name
    "Matt"
    ```
  - By default, comprehensions will return a list the `into:` parameter
    can be used to override this:
    ```shell
    iex> for x <- ~{ben, sue}, into: %{}, do: {x, String.upcase(x)}
    %{ben: "BEN", sue: "SUE"}
    iex> for x <- ~{ben, sue}, into: Map.new, do: {x, Stringupcase(x)}
    %{ben: "BEN", sue: "SUE"}
    ```
    - The `into:` value doesn't have to be empty
    - The `into:` values need to implement the `Collectable` protocol, which
      includes:
      - Lists
      - Binaries
      - Functions
      - Maps
      - Files
      - Hash dictionaries
      - Hash sets
      - IO streams

# Ch 11: Strings & Binaries
- Elixir has 2 kinds of strings: double- and single-quoted
- Commonalities between string types:
  - Contain UTF-8 characters & escape sequences (like `\n`)
  - Allow interpolation with `#{}`
  - Escape special characters with `\`; so `\n` can be displayed by doing `\\n`
  - Support heredocs
- Heredocs
  - Strings can span multiple lines and retain their leading & trailing spacing
   (not `IO.write/1` is like `IO.puts/1` without auto-inserting a new line at
   the end)
  - Heredocs fix that, by cutting down on leading/trailing spacing and
    newlines
  - The code in `heredocs.exs` produces the following output:
    ```shell
    --start--

          my
        string
        --end--
    --start--
      my
    string
    --end--
    ```
  - Here docs are used for adding docs about functions & modules
- Sigils: alternative syntax for _some_ literals
  - Format is: `~<letter>{<content>}[<options>]`
  - The `{}` delimiters could also be: `[]`, `()`, `||`, `//`, `""`, and `''`
    - Using the opening delimiter before the closing delimiter will not start
      a new sequence, so `{a{b}` is the sequence `a{b`
    - If the opening delimiter is `"""` or `'''`, the sequence is treated like
      a heredoc
  - Letters are sigil type:
    Letter|Meaning
    ---|---
    `C`|Character list with no escaping or interpolation
    `c`|Character list, escaped & interpolated like single-quote string
    `D`|A `Date` in the `yyyy-MM-dd` format
    `N`|A naive `DateTime` in the format `yyyy-MM-dd hh:mm:ss[.ddd]`
    `R`|A regex with no escaping or interpolation
    `r`|A regex with escaping & interpolation
    `S`|A string with no escaping or interpolation
    `s`|A string with escaping & interpolation
    `T`|A `Time` in the `hh:mm:ss[.ddd]` format
    `W`|A list of whitespace-delimited words, with no escaping or interpolation
    `w`|A list of whitespace-delimited words, with escaping & interpolation
    - `~W` & `~w` take an optional type specifier on what type to return in the
      list
      Option|Return type
      a|Atoms
      c|Character
      s|Strings
  - You can define your own sigils, too (explain in part III)
- "Strings" vs 'character lists'
  - Single-quoted strings are called character lists
  - Double-quoted strings are strings
  - String libraries only work with double-quoted
- Character lists
  - Strings represented as a list of character code integers
  ```shell
  iex> str = 'wombat'
  'wombat'
  iex> is_list str
  true
  iex> Enum.reverse str
  'tamow'
  iex> :io.format "~w~n", [str]
  [119,111,109,98,97,116]
  :ok
  iex> str ++ [0]
  [119, 111, 109, 98, 97, 116, 0]
  ```
    - The `:io.format/2` uses Erlang's formatting where `~w` displays each
      character as an Erlang term (the integer) and `~n` says add a newline
    - The joining of `str` & `[0]` adds `0` to the end of list, making it
      unprintable (since `0` is not a valid character code), so Elixir just
      outputs it as a list
  - Because they're lists, character lists can use all the `List`/`Enum`
    functions
  - Prefixing a character with `?` will return its character code
    ```shell
    iex> ?a
    97
    iex> ?A
    65
    iex> ?z
    122
    iex> [?y]
    'y'
    iex> ?z + 13
    135
    iex> [?z + 13]
    [135]
    iex> [?q + 3]
    't'
    ```
- Binaries: represent a sequence of bits
  - Literal format: `<< term_1, term_2, ... >>`
    - Simplest term is a number in 0..255
    - Numbers stored as successive bytes
  - Getting the size of binary is as easy as:
    - `byte_size <binary>`: gets size of binary in bytes
    - `bit_size <binary>`: gets size of binary in bits
  - Terms can be sized using the `size` modifier:
    ```shell
    iex> nary = << 1::size(2), 1::size(3) >>  # 01 001 = 9
    <<9::size(5)>>
    ```
  - Binaries can contain integers, floats, and other binaries
  - **Double-quote strings are binaries**
    - This means characters that a charlist has trouble with, a string will not
      ```shell
      iex> '∂x/∂y'
      [8706, 120, 47, 8706, 121]
      iex> "∂x/∂y"
      "∂x/∂y"
      ```
  - UTF-8 characters can take up more than 1 byte, so the length of a string and
    the length of its binary do not _necessarily_ equal
    ```shell
    iex> byte_size "∂x/∂y"
    9
    iex> String.length "∂x/∂y"
    5
    ```
- `String` module: works on double-quote strings (binaries)
  - Has functions for working with graphemes and codepoints
    - Grapheme: a complete UTF-8 character, like `ë`
    - Codepoint: each part of the UTF-8 character, `ë` is actually
      `["e", "̈"]`
- Binaries and pattern matching
  - First rule of binaries: "if in doubt, specify the type of each field"
  - Types:
    - `binary`
    - `bits`
    - `bytes`
    - `float`
    - `integer`
    - `utf8`
    - `utf16`
    - `utf32`
  - Qualifiers:
    - `size(n)`: field size, in bits
    - `signed`/`unsigned`
    - endianness: `big`, `little`, `native`
      - Little endian: least significant element in lowest position
      - Big endian: least significant element in highest position
  - Hyphens (`-`) should be used to separate multiple attributes for a field
  - Most work with binaries is to process UTF-8 strings
    - Binary files & protocol formats utilize the above tools as well
- String Processing with Binaries

# Ch 12: Control Flow
- Elixir has a small set of control flow constructs
  - In Elixir, the aim is to use guard clauses & small pattern-matching
    functions to take the place of `if/then` logic
- `if` & `unless` work inversely of each other:
  - `if` works as it does in other languages
    ```shell
    iex> if 1 == 1, do: "truth!", else: "false..."
    "truth"
    iex> if 1 == 2, do: "truth!", else: "false..."
    "false..."
    ```
    - `if...do` can be written similar to function definitions:
      ```elixir
      if condition do
        "truth!"
      else
        "false..."
      end
      ```
  - `unless` is similar to `if`
    ```shell
    iex> unless 1 == 1, do: "not ok :(", else: "OK!"
    "OK!"
    iex> unless 1 == 2, do: "not ok :(", else: "OK!"
    "not ok :("
    ```
    - And it can also be written with syntactic sugar:
      ```elixir
      unless 1 == 2 do
        "not ok :("
      else
        "OK!"
      end
      ```
- `cond` is another conditional construct:
  ```elixir
  cond do
    bass >= 7 ->
      "heavy!"
    bass > 3 ->
      "mid-range"
    bass >= 1 ->
      "low"
    true ->
      "off"
  end
  ```
  - `true ->` is a fall-through
  - It's usually better to use functions instead of `cond` with pattern
    matching
- `case` is similar to `switch`:
  ```elixir
  case some_variable do
    %{state: "NJ"} ->
      "An anonymouse person from NJ!"
    person = %{age: age} and is_number(age) and age >= 21 ->
      "#{person.name} can drink!"
    _ ->
      "A young person not from NJ!"
  end
  ```
- Exceptions _can_ be raised but is done far less than in other languages
  - In Elixir, errors propogate back up to a supervising application
  - In general, avoid using exceptions as best you can
  - Exceptions should be used for things that should never happen
    - For example, a known file not opening
    - If a user enters a file name, the file not opening should be an
      expected error
  - Functions with a trailing `!` are ones that raise an exception, such as
    `File.open!`

# Ch 13: Organizing a Project
- This chapter develop s a project for pulling the last _n_ issues from a
  Github project, with these reqs:
  - Need an HTTP client to access GitHub API
    - URL: https://api.github.com/repos/:user/:project/issues
  - API returns JSON, so we need a JSON-handling library
  - Sort the data
  - Display as a table
- The aim is to use `mix` (package manager) and `ExUnit` (testing library)
- Step 1: Use Mix to create project
  - Elixir comes with `mix`
  - `mix` runs from the command line (not from within `iex`)
  - `mix help` shows standard tasks
    ```shell
    $> mix help
    mix                   # Runs the default task (current: "mix run")
    mix app.start         # Starts all registered apps
    mix app.tree          # Prints the application tree
    ...
    ix xref              # Performs cross reference checks
    iex -S mix            # Starts IEx and runs the default task
    ```
  - `mix help <command>` will give info about that command
    ```shell
    $> mix help deps
    mix deps

    Lists all dependencies and their status.
    ...
    ```
  - **To create a new project run `mix new <project_name>`:
    ```shell
    $> mix new issues
    * creating README.md
    * creating .formatter.exs
    * creating .gitignore
    * creating mix.exs
    * creating config
    * creating config/config.exs
    * creating lib
    * creating lib/issues.ex
    * creating test
    * creating test/test_helper.exs
    * creating test/issues_test.exs

    Your Mix project was created successfully.
    You can use "mix" to compile it, test it, and more:

        cd issues
        mix test

    Run "mix help" for more commands.
    ```
    - This creates an `issues` directory with the above files in it from
      wherever the command is run
    - Files/folders created:
      - `.formatter.exs`: used by source code formatter
      - `.gitignore`: is a Git file for ignoring files from being comiitable
      - `README.md`: a file for describing & documenting your project; very
        useful with Github
      - `mix.exs`: project configuration
      - `config/`: application-specific configuration
      - `lib/`: source code directory
      - `test/`: test code directory
  - It's a good idea to use version control, like `git`
- Step 2: Parse the Command Line
  - Handling command options will be in a module separate from the main code
  - The module will be named `CLI`
    - As part of the `Issues` project, it'll be named `Issues.CLI`
    - Elixir conventions puts this module file at `lib/issues/cli.ex`
  - Elixir has an option-parsing library, which this project will use
    - `-h` and `--help` will be optional switches
    - Anything else is an argument
    - The library returns a tuples
- Step 3: Write Some (Basic) Tests
  - Elixir comes with the `ExUnit` framework for testing
  - When the project was created, `lib/issues.ex` was created with a `hello`
    function; it also created `test/issues_test.exs` which tests that file
  - Create a `test/cli_test.exs` file (see `issues` directory)
    - Test file names _must_ end with `_test`
    - We test that:
      - `-h` & `--help` return `:help`
      - Passing a user, project, & count returns it as a tuple:
        `{user, project, count}`
      - Passing a user & project returns the tuple with a default count:
        `{user, project, 4}`
    - `test` & `assert` are macros from `ExUnit.Case`
      - `assert` will gather info and display it when that assertion fails
  - To run tests use `mix test`:
    ```shell
    $> mix test
    Compiling 2 files (.ex)
    Generated issues app
    .....

      1) test returns a tuple with user, project, & count if all are provided (CliTest)
        test/cli_test.exs:14
        Assertion with == failed
        code:  assert parse_args(["fake_user", "some_proj", "15"]) == {"fake_user", "some_project", 15}
        left:  {"fake_user", "some_proj", "15"}
        right: {"fake_user", "some_project", 15}
        stacktrace:
          test/cli_test.exs:15: (test)



    Finished in 0.2 seconds
    2 doctests, 4 tests, 1 failure

    Randomized with seed 738404
    ```
    - Our tests fail because we're expecting the integer `15` back but getting
      the string `"15"` back (see this with `git checkout ch13-failed-cli-test`)
    - To fix this, we can use `String.to_integer and when the tests run:
      ```shell
      $> mix test
      ......

      Finished in 0.2 seconds
      2 doctests, 4 tests, 0 failures

      Randomized with seed 739436
      ```
      - Check this out with `git checkout ch13-passed-cli-test`
- Step 4: Processing Help
  - The `parse_args` function has two problems:
    - It's large (by Elixir conventions)
    - It uses conditional logic where pattern-matching function definitions
      would do
  - We can refactor it and our tests will make sure we didn't mess up
  - To see the refactored code checkout `ch13-cli-refactor`
- Step 5: Fetch from Github
  - Next we need a way of processing the values returned from `pargs_args`
    - Output help for `:help`
    - Fetch issues for the tuple
  - See the tag `ch13-process-help` for the code
  - To check this code we use `mix run`:
    ```shell
    $> mix run -e 'Issues.CLI.run(["-h"])'
    Compiling 2 files (.ex)
    warning: function Issues.GithubIssues.fetch/2 is undefined (module Issues.GithubIssues is not available)
      lib/cli.ex:55

    Generated issues app
    usage: issues <user> <project> [count | 4]
    ```
    - Trying to pass a user & project will fail since we have no module
      named `Issues.GithubIssues`
- Step 6: Using a Library
  - Elixir has a lot of built-in libraries; find them using the docs at
    https://elixir-lang.org/docs
  - Elixir can also leverage Erlang's built-ins; find them under the
    _Application Groups_ section at http://erlang.org/doc
  - For other libraries, Elixir uses `hex`, at https://hex.pm
    - If they can't be found there, use Github and/or Google
  - To do HTTP requests, we'll use `HTTPoison`
  - Adding HTTPoison
    - Mix handles this by using the dependency list in `mix.exs` and running
      `mix deps`
    - We add `:httposion` with a version of `"~> 1.0.0"` to get HTTPoison with
      a version >= 1.0
    - To see this use tag `ch13-httpoison-installed`
    - Dependencies & their status can be listed with `mix deps`:
      ```shell
      $> mix deps
      * httpoison (Hex package)
      the dependency is not available, run "mix deps.get"
      ```
    - Install the missing deps with `mix deps.get`:
      ```shell
      $> mix deps.get
      Resolving Hex dependencies...
      Dependency resolution completed:
      New:
        certifi 2.5.1
        hackney 1.15.1
        httpoison 1.0.0
        idna 6.0.0
        metrics 1.0.1
        mimerl 1.2.0
        parse_trans 3.3.0
        ssl_verify_fun 1.1.4
        unicode_util_compat 0.4.1
      * Getting httpoison (Hex package)
      * Getting hackney (Hex package)
      * Getting certifi (Hex package)
      * Getting idna (Hex package)
      * Getting metrics (Hex package)
      * Getting mimerl (Hex package)
      * Getting ssl_verify_fun (Hex package)
      * Getting unicode_util_compat (Hex package)
      * Getting parse_trans (Hex package)
      ```
      - Now running `mix deps` yields better results:
        ```shell
        $> mix deps
        * mimerl (Hex package) (rebar3)
        locked at 1.0.2 (mimerl) 993f9b0e
        the dependency build is outdated, please run "mix deps.compile"
        * metrics (Hex package) (rebar3)
        locked at 1.0.1 (metrics) 25f094de
        the dependency build is outdated, please run "mix deps.compile"
        * unicode_util_compat (Hex package) (rebar3)
        locked at 0.3.1 (unicode_util_compat) a1f612a7
        the dependency build is outdated, please run "mix deps.compile" ...
        * httpoison (Hex package) (mix)
        locked at 0.9.0 (httpoison) 68187a2d
        the dependency build is outdated, please run "mix deps.compile"
        ```
      - Mix will compile the above libraries when we need them
      - Mix also added a `deps` directory where it stores these installed
        dependencies
  - Adding `GithubIssues.fetch`
    - Add a file at `lib/github_issues.ex` to render the URL and fetch
      data using Github's API
    - We use HTTPoison's `get` function which will return a tuple of
      `{:ok, response}` for a `OK` HTTP response
    - NOTE: HTTPoison's docs tell you to use `HTTPoison.start` but
      Elixir will do this for you
      - Becuse it's listed as a dependency, Elixir will run it as a separate
        application
        - In Elixir an sub-application is similar to a library in other
          languages
    - The `github_issues.ex` code can be seen at tag `ch13-handle-fetch`
- Step 7: Transforming JSON
  - To transform the JSON, we need a library, poison
    - Add `{:poison, "~> 3.1"}` to `mix.exs`
    - Run `mix deps.get` to install poison
  - Poison's `Parser.parse!` function will convert the JSON string into a
    list of maps
    - This will be part of the pipeline in `github_issues.ex`
    - That pipeline also gets some refactoring for clarity
  - In `cli.ex` we have to decode the response from `GithubIssues`
    - This just turns any tuple with `:ok` as its first item and returns its
      body
    - Any other response returns an error message
  - This code is available at `ch13-process-json`
- Step 8: Making the URL Configurable
  - The URL for Github is hardcorded in `lib/github_issues.ex`
  - Mix added a `config/` directory as part of `mix new`
  - The file `config.exs` contains application-level config
    - To this we add an `github_url` key with a value of
      `"https://api.github.com"` as part of the `:issues` application
  - Update `lib/github_issues.ex` to use the new environment variable
    by using `Application.get_env`
  - These two changes can be seen with `ch13-config-url`
  - Configs can be perscribed per-environment by using `import_config` like:
    ```elixir
    use Mix.Config

    import_env "#{Mix.env}.exs"
    ```
    - In a `dev` environment, this will pull in `dev.exs`, production
      `prod.exs`, etc.
- Step 9: Sorting the Results
  - Elixir's `sort/2` will make sorting on `created_at` a cinch
  - Add it to the `CLI` module with intent to refactor whenever a better
    module shows itself
  - This code (and its tests) can be seen with the tag `ch13-sort`
