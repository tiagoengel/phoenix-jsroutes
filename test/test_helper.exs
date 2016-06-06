defmodule TestHelper do
  import ExUnit.Assertions

  @doc """
  Asserts file exists in the filesystem
  """
  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  @doc """
  Asserts that file exists and its contents are matched by `match`.
  `match` can be a binary, a regex or a list. If it's a list, every member of the list
  must match with the file contents.
  """
  def assert_file(file, match) when is_list(match) do
    assert_file file, &(Enum.each(match, fn(m) -> assert &1 =~ m end))
  end

  def assert_file(file, match) when is_binary(match) or is_map(match) do
    assert_file file, &(assert &1 =~ match)
  end

  @doc """
  Assert that file exists and pass its contents to a function for further assertions.
  """
  def assert_contents(file, match) when is_function(match, 1) do
    assert_file(file)
    match.(File.read!(file))
  end

  @doc """
  Assert that a file does NOT exist.
  """
  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

end

# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

ExUnit.start()
