defmodule Lixir do
  @moduledoc """
  A simple LISP interpreter written in Elixir.
  """

  @doc "Starts the Read-Eval-Print-Loop."
  def repl do
    IO.puts("Lixir 0.1.0")
    IO.puts("Press Ctrl+C to exit")

    loop(%{})
  end

  defp loop(env) do
    input =
      IO.gets("lixir> ")
      |> to_string()
      |> String.trim()

    {result_val, new_env} = execute_and_print(input, env)

    if result_val != :ok do
      IO.inspect(result_val)
    end

    loop(new_env)
  end

  defp execute_and_print("", env), do: {:ok, env}

  defp execute_and_print(input, env) do
    try do
      input
      |> parse()
      |> eval(env)
    rescue
      e ->
        IO.puts("Error: #{e.message}")
        {:ok, env}
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

  # somewhere here I should learn how to parse strings
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
    case token do
      token when is_integer(token) ->
        case Integer.parse(token) do
          {int, ""} -> int
          _ -> String.to_atom(token)
        end

      token when is_float(token) ->
        case Float.parse(token) do
          {float, ""} -> float
          _ -> String.to_atom(token)
        end

      _ ->
        String.to_atom(token)
    end
  end

  defmodule Closure do
    defstruct [:params, :body, :env]
  end

  def bin_op(:+, a, b), do: a + b
  def bin_op(:-, a, b), do: a - b
  def bin_op(:*, a, b), do: a * b
  def bin_op(:/, a, b), do: a / b

  def eval(expression, env) when is_number(expression), do: {expression, env}

  def eval([op, a, b], env) when op in [:+, :-, :*, :/] do
    {val_a, _} = eval(a, env)
    {val_b, _} = eval(b, env)
    {bin_op(op, val_a, val_b), env}
  end

  def eval(symbol, env) when is_atom(symbol) do
    case Map.fetch(env, symbol) do
      {:ok, value} -> {value, env}
      :error -> raise "Undefined variable: '#{symbol}'"
    end
  end

  def eval([:def, symbol, val], env) do
    {new_val, new_env} = eval(val, env)
    {new_val, Map.put(new_env, symbol, new_val)}
  end

  def eval([:lambda, params, body], env) do
    {%Closure{params: params, body: body, env: env}, env}
  end

  def eval([%Closure{params: params, body: body, env: closure_env} | args], env) do
    evaluated_args = Enum.map(args, fn arg -> elem(eval(arg, env), 0) end)

    local_env = Enum.zip(params, evaluated_args) |> Enum.into(%{})

    final_env = Map.merge(closure_env, local_env)

    eval(body, final_env)
  end

  # def eval([%Closure{params: params, body: body, env: closure_env} | args], env) do
  #   {all_evaluated_args, _final_arg_env} =
  #     args
  #     |> Enum.reduce({[], env}, fn {arg, {evaluated_args, arg_env}} ->
  #       {evaluated_arg, new_arg_env} = eval(arg, arg_env)
  #       {[evaluated_arg | evaluated_args], new_arg_env}
  #     end)

  #   local_env = Enum.zip(params, all_evaluated_args) |> Enum.into(%{})
  #   final_env = Map.merge(closure_env, local_env)

  #   eval(body, final_env)
  # end
end

Lixir.repl()
