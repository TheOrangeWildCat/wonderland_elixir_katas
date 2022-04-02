defmodule FoxGooseBagOfCorn.Puzzle do
  @start_position [
    [[:fox, :goose, :corn, :you], [:boat], []]
  ]

  @restrictions [
    [:fox, :goose],
    [:goose, :corn],
    [:goose, :fox],
    [:corn, :goose],
    [:you],
    [:fox, :goose, :corn],
    [:fox, :corn, :goose],
    [:corn, :fox, :goose],
    [:corn, :goose, :fox],
    [:goose, :corn, :fox],
    [:goose, :fox, :corn]
  ]

  def river_crossing_plan do
    # Implement this with an algorithm.
    # Hard coding the solution is easy! ;-)
    # [
    #   [[:fox, :goose], [:boat, :you, :corn, :goose], [:you]],
    #   [[:goose, :corn], [:boat], [:you]]
    # ]
    next_move(@start_position, from: :left, to: :center)
    |> List.last()
    |> Enum.reverse()
  end

  def to_set(list) when is_list(list), do: Enum.into(list, HashSet.new())
  def step_to_sets(step), do: step |> Enum.map(&to_set/1)

  @doc """
    Defines a sigil for a HashSet of atoms

    Example:
    iex> import #{__MODULE__}
    iex> ~H":a :b :c"
    #HashSet<[:c, :b, :a]>
    iex> ~H""
    #HashSet<[]>
  """
  def sigil_H(str, _opts) do
    str
    |> String.split(" ")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&String.replace(&1, ":", ""))
    |> Enum.map(&String.to_atom/1)
    |> Enum.into(HashSet.new())
  end

  def next_direction(from: a, to: b) do
    case {a, b} do
      {:left, :center} -> {:center, :right}
      {:center, :right} -> {:right, :center}
      {:right, :center} -> {:center, :left}
      {:center, :left} -> {:left, :center}
    end
  end

  def next_move([[l, c, r] | ls] = plan, from: a, to: b) do
    valid_element =
      move([l, c, r], from: a, to: b)
      |> IO.inspect()
      |> Enum.filter(&is_valid/1)
      |> Enum.filter(fn elem -> elem not in plan end)

    if length(valid_element) != 0 do
      valid_element
      |> Enum.flat_map(fn f ->
        {n_from, n_to} = next_direction(from: a, to: b)
        # |> IO.inspect()
        # f |> IO.inspect()
        next_move([f | plan], from: n_from, to: n_to)
      end)
    else
      [plan]
    end
  end

  def is_valid([l, c, r]) do
    not Enum.member?(@restrictions, l) and not Enum.member?(@restrictions, r) and
      not (length(c) > 3)
  end

  def move([l, c, r], from: :left, to: :center) do
    Enum.map(l, fn a ->
      [l -- [:you, a], c ++ [:you, a], r]
    end)
    |> Enum.map(&Enum.map(&1, fn mov -> Enum.uniq(mov) end))
  end

  def move([l, c, r], from: :right, to: :center) do
    Enum.map(r, fn a ->
      [l, c ++ [:you, a], r -- [:you, a]]
    end)
    |> Enum.map(&Enum.map(&1, fn mov -> Enum.uniq(mov) end))
  end

  def move([l, c, r], from: :center, to: :left) do
    Enum.map(c -- [:boat], fn a ->
      [l ++ [:you, a], c -- [:you, a], r]
    end)
    |> Enum.map(&Enum.map(&1, fn mov -> Enum.uniq(mov) end))
  end

  def move([l, c, r], from: :center, to: :right) do
    Enum.map(c -- [:boat], fn a ->
      [l, c -- [:you, a], r ++ [:you, a]]
    end)
    |> Enum.map(&Enum.map(&1, fn mov -> Enum.uniq(mov) end))
  end
end
