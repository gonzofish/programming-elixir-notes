defmodule StringFormat do
  def capitalize_sentences(sentences) do
    String.split(sentences, ". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end
