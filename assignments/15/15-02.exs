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
        "Received #{token} back"
    after
      1000 ->
        "Game over..."
    end
  end
end

"""
iex(1)> c "15-02.exs"
[Neeq]
iex(2)> fred_pid = spawn(Neeq, :listen_and_send, [])
#PID<0.115.0>
iex(3)> betty_pid = spawn(Neeq, :listen_and_send, [])
#PID<0.117.0>
iex(4)> send(fred_pid, {self(), :fred})
{#PID<0.108.0>, :fred}
iex(5)> send(betty_pid, {self(), :betty})
{#PID<0.108.0>, :betty}
iex(6)> Neeq.listen()
"Received fred back"
iex(7)> Neeq.listen()
"Received betty back"
iex(8)> Neeq.listen()
"Game over..."
"""
