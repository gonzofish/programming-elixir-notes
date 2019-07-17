defmodule Chain do
  def counter(next_pid) do
    receive do
      n -> send(next_pid, n + 1)
    end
  end

  def create_processes(n) do
    spawner = fn _, send_to ->
      spawn(Chain, :counter, [send_to])
    end

    # spawn n processes, return the PID of
    # the newly created process
    last = Enum.reduce(1..n, self(), spawner)

    # call the last PID with 0
    # it will call the previous processe with 1
    # it will call the previous process with 2
    # ...
    # it will call the previous process with n
    send(last, 0)

    receive do
      # this guard clause lets us ignore any other 
      # messages, such as one in some versions of
      # Elixir that notifies of a process's termination
      final_answer when is_integer(final_answer) ->
        "The result is: #{inspect(final_answer)}"
    end
  end

  def run(n) do
    # :time.tc does function execution timing,
    # returning {time_in_microseconds, return_value}
    :timer.tc(Chain, :create_processes, [n])
    |> IO.inspect()
  end
end
