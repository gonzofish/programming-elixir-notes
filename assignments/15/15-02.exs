defmodule Neeq do
  @doc """
  Neeq, for "unique"
  """

  def listen_and_send do
    receive do
      {sender, token} ->
        send(sender, token)
        listen_and_send()
    end
  end

  def listen do
    receive do
      token ->
        IO.puts("Received #{token} back")
    after
      1000 ->
        IO.puts("Game over...")
    end
  end
end

fred_pid = spawn(Neeq, :listen_and_send, [])
betty_pid = spawn(Neeq, :listen_and_send, [])

send(fred_pid, {self(), :fred})
Neeq.listen()

send(betty_pid, {self(), :betty})
Neeq.listen()

Neeq.listen()

"""
iex(1)> c "15-02.exs"
Received fred back
Received betty back
Game over...
[Neeq]
"""
