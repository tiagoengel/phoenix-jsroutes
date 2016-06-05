defmodule PhoenixJsrouter.UrlTransformer do
  def to_js(path) do
    result = %{ index: 0, length: String.length(path), path: path, state: "start_path", code: "" }
    do_recur(result).code
  end

  defp consume(%{index: index} = result) do
    result |> Map.put(:index, index + 1)
  end

  defp move_state(result, name) do
    Map.put(result, :state, name)
  end

  defp current_char(result) do
    result.path |> String.at(result.index)
  end

  defp do_recur(%{index: index, length: length} = result) when index == length do
    end_path(result)
  end

  defp do_recur(result) do
    result = invoke_state(result)
    do_recur(result)
  end

  defp invoke_state(result) do
    case result do
      %{state: "start_path"} -> start_path(result)
      %{state: "start_string"} -> start_string(result)
      %{state: "end_string"} -> end_string(result)
      %{state: "append_string"} -> append_string(result)
      %{state: "start_var"} -> start_var(result)
      %{state: "end_var"} -> end_var(result)
      %{state: "append_var"} -> append_var(result)
    end
  end

  # states

  defp start_path(result) do
    char = current_char(result)

    if char == ":" do
      result |> consume |> move_state("append_var")
    else
      result |> move_state("start_string")
    end
  end

  defp start_string(result) do
    result
    |> Map.update!(:code, &(&1 <> "'"))
    |> move_state("append_string")
  end

  defp end_string(result) do
    result
    |> Map.update!(:code, &(&1 <> "'"))
    |> move_state("start_var")
  end

  defp append_string(result) do
    char = current_char(result)

    result = consume(result)

    if char == ":" do
      result |> move_state("end_string")
    else
      result |> Map.update!(:code, &(&1 <> char))
    end
  end

  defp start_var(result) do
    result
    |> Map.update!(:code, &(&1 <> " + "))
    |> move_state("append_var")
  end

  defp end_var(result) do
    result
    |> Map.update!(:code, &(&1 <> " + "))
    |> move_state("start_string")
  end

  defp append_var(result) do
    char = current_char(result)

    if char == "/" do
      result |> move_state("end_var")
    else
      result
      |> consume
      |> Map.update!(:code, &(&1 <> char))
    end
  end

  defp end_path(%{state: "append_string"} = result) do
    result |> end_string
  end

  defp end_path(result) do
    result
  end
end
