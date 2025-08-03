defmodule Lixir do
  @moduledoc """
  A simple LISP interpreter written in Elixir.
  """

  @doc "Starts the Read-Eval-Print-Loop."
  def repl do
    IO.puts("Lixir 0.1.0")
    IO.puts("Press Ctrl+C to exit")

    loop()
  end

  defp loop do
    IO.gets("lixir> ")
    |> to_string()
    |> String.trim()
    |> execute_and_print()

    loop()
  end

  defp execute_and_print(""), do: :ok

  defp execute_and_print(input) do
    try do
      result =
        input
        |> parse()
        |> eval()

      IO.inspect(result, pretty: true)
    rescue
      e -> IO.puts("Error: #{e.message}")
    end
  end

  @doc "Parses a string into an Elixir data structure."
  def parse(string) do
    string
    |> tokenize()
    |> parse_tokens()
    |> elem(0)
  end

  defp tokenize(string) do
    string
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
  end

  defp parse_tokens(["(" | rest_tokens]) do
    build_list(rest_tokens, [])
  end

  defp parse_tokens(tokens) do
    {read_atom(hd(tokens)), tl(tokens)}
  end

  defp build_list([")" | rest_tokens], acc) do
    {Enum.reverse(acc), rest_tokens}
  end

  defp build_list(tokens, acc) do
    {parsed_element, remaining_tokens} = parse_tokens(tokens)

    build_list(remaining_tokens, [parsed_element | acc])
  end

  defp read_atom(token) do
    case Integer.parse(token) do
      {int, ""} -> int
      _ -> String.to_atom(token)
    end
  end

  def eval(ast) do
    # todo
    ast
  end
end

Lixir.repl()
