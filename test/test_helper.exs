defmodule TestHelper do
  import ExUnit.Assertions

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

   def refute_file(file) do
     refute File.regular?(file), "Expected #{file} to not exist, but it does"
   end

   def assert_file(file, match) do
     cond do
       is_list(match) ->
         assert_file file, &(Enum.each(match, fn(m) -> assert &1 =~ m end))
       is_binary(match) or Regex.regex?(match) ->
         assert_file file, &(assert &1 =~ match)
       is_function(match, 1) ->
         assert_file(file)
         match.(File.read!(file))
     end
   end
end

# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

ExUnit.start()
