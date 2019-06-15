defmodule Countdown do
  def sleep(seconds) do
    receive do
      after seconds * 1000 -> nil
    end
  end

  def say(text) do
    spawn fn -> :os.cmd('say #{text}') end
  end

  def timer do
    Stream.resource(
      # start_func
      fn ->
        {_, _, s} = :erlang.time
        # number of seconds until the next minute
        60 - s - 1
      end,
      # process_func
      fn
        0 -> {:halt, 0}
        count ->
          sleep(1)
          {[inspect(count)], count - 1}
      end,
      # end_func (nothing to deallocate)
      fn _ -> nil end
    )
  end
end
