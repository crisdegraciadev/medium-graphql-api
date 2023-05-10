defmodule Test.Support.Fixtures.Errors do
  def check_error_structure(error) do
    properties = ["locations", "message", "path"]
    Enum.all?(properties, fn prop -> Map.has_key?(error, prop) end)
  end
end
