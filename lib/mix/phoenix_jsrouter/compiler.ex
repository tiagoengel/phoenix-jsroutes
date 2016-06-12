defmodule Mix.Compilers.Phoenix.JsRoutes do
  @moduledoc false

  @manifest_vsn :v1

  @doc """
  This compiler works a little bit different than the usual in the sense that it does not compile sources,
  it compiles Router modules into javascript files instead.

  The big difference is that the ```source files``` are in fact ```source modules```
  and to decide if an input is stale or not the compiler uses the module's md5 hash.

  Also, considering that the compiler supports configuring the output folder, it
  removes dests that does not have dests (I find it confusing too...)

  For instance, if the output folder was configured to `web/static/js` the manifest
  would have and entry pointing to this folder. If, after that, the user changes the
  outuput folder, there will be no more source pointing to this output, so it will
  be removed.
  """

  def compile(manifest, mappings, force, callback) do
    entries = read_manifest(manifest)
    stale = Enum.filter(mappings, fn {module, dest} ->
      entry = find_manifest_entry(entries, module)
      force || stale?(module, entry) || output_changed?(dest, entry)
    end)

    # Files to remove are the ones where the output in the mappings is diferent from
    # the output in the entries
    files_to_remove = Enum.filter(entries, fn {module, _, dest} ->
      Enum.any?(mappings, fn {mapping_module, mapping_out} ->
        mapping_module == module && mapping_out != dest
      end)
    end)

    # Entries to remove are the ones that are in the manifest but not in the mappings
    entries_to_remove = Enum.reject(entries, fn {module, _, _} ->
      Enum.any?(mappings, fn {mapping_module, _} ->
        mapping_module == module
      end)
    end)

    compile(manifest, entries, stale, entries_to_remove, files_to_remove, callback)
  end

  defp compile(manifest, entries, stale, entries_to_remove, files_to_remove, callback) do
    if stale == [] && entries_to_remove == [] && files_to_remove == [] do
      :noop
    else
      Mix.Project.ensure_structure()

      Enum.each(entries_to_remove ++ files_to_remove, &File.rm(elem(&1, 2)))

      # Compile stale files and print the results
     results = for {module, output} <- stale do
       log_result(output, callback.(module, output))
     end

     # New entries are the ones in the stale array
     new? = fn {module, _, _} -> Enum.any?(stale, &elem(&1, 0) == module) end

     entries = (entries -- entries_to_remove) |> Enum.filter(&!new?.(&1))
     entries = entries ++ Enum.map(stale, fn {module, dest} ->
       {module, module.module_info[:md5], dest}
     end)

     write_manifest(manifest, :lists.usort(entries))

     if :error in results do
       Mix.raise "Encountered compilation errors"
     end
     :ok

    end
  end

  @doc """
  Cleans up compilation artifacts.
  """
  def clean(manifest) do
    read_manifest(manifest)
    |> Enum.each(fn {_, _, output} -> File.rm(output) end)
  end

  defp stale?(_, {nil, nil, nil}), do: true
  defp stale?(module, {_, hash, _}) do
    module.module_info[:md5] != hash
  end

  defp output_changed?(dest, {_, _, manifest_dest}) do
    dest != manifest_dest
  end

  defp find_manifest_entry(manifest_entries, module) do
    Enum.find(manifest_entries, {nil, nil, nil}, &elem(&1, 0) == module)
  end

  def read_manifest(manifest) do
    case File.read(manifest) do
      {:error, _} -> []
      {:ok, content} ->
        :erlang.binary_to_term(content) |> parse_manifest
    end
  end

  defp parse_manifest({@manifest_vsn, entries}), do: entries
  defp parse_manifest({version,_}) do
    Mix.raise "Unsupported manifest version (#{version})"
  end

  defp write_manifest(manifest, entries) do
    content = {@manifest_vsn, entries} |> :erlang.term_to_binary
    File.write(manifest, content)
  end

  defp log_result(output, result) do
    case result do
      :ok ->
        Mix.shell.info "Generated #{output}"
        :ok
      {:error, error} ->
        Mix.shell.info "Error generating #{output}\n#{inspect error}"
        :error
    end
  end

end
