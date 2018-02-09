defmodule PropertyTesting do
  @moduledoc """
  Documentation for PropertyTesting.
  """

  use ExUnitProperties

  @doc """
  Hello world.

  ## Examples

      iex> PropertyTesting.hello
      :world

  """
  def hello do
    :world
  end

  def generate_uri do
    gen all host <- one_of([generate_host(), nil]),
            scheme <- member_of(["http", "https", "ftp"]) do

      URI.to_string(%URI{host: host, scheme: scheme})
    end
  end

  def generate_split_binary(my_string) do
    gen all split_points <- generate_split_points(my_string) do
      {rem, off, list} =
        split_points
        |> Enum.reduce({my_string, 0, []}, fn point, {remaining, offset, splits} ->
          {first, second} = String.split_at(remaining, point - offset)

          {second, offset + String.length(first) - 1, [first | splits]}
        end)

      Enum.reverse([rem | list])
    end
  end

  def generate_split_points(string) do
    max = String.length(string) - 1
    gen all a <- uniq_list_of(integer(0..max)), do: Enum.sort(a)
  end

  def generate_host do
    gen all site <- string(:alphanumeric, min_length: 2),
            ext <- member_of(["com", "gov", "biz"]),
            do: "#{site}.#{ext}"
  end
end
