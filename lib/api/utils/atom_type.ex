defmodule Api.Utils.AtomType do
  use Ecto.Type

  def type, do: :string

  # From web
  def cast(value), do: {:ok, value}

  # From database
  def load(value), do: {:ok, String.to_atom(value)}

  # To database
  def dump(value) when is_atom(value), do: {:ok, Atom.to_string(value)}
  def dump(_), do: :error
end
