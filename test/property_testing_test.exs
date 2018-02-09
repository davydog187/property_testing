defmodule PropertyTestingTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest PropertyTesting

  test "greets the world" do
    assert PropertyTesting.hello() == :world
  end

  property "always true" do
    check all a <- integer() do
      assert is_integer(a)
    end
  end

  property "sorted lists" do
    check all a <- list_of(term(), min_length: 1, max_length: 10), max_runs: 50 do
      sorted = :lists.sort(a)

      assert is_list(sorted)

      Enum.reduce(sorted, fn current, acc ->
        assert acc <= current

        current
      end)
    end
  end

  property "Map.merge/2" do
    check all a <- map_of(term(), term()),
              b <- map_of(term(), term()), max_runs: 10 do

      merged = Map.merge(a, b)

      for {key, value} <- merged do
        in_a? = Map.has_key?(a, key)
        in_b? = Map.has_key?(b, key)

        if in_a? and in_b? do
          assert value == Map.get(b, key)
        else
          assert in_a? or in_b?
        end
      end
    end
  end

end
