defmodule FoxGooseBagOfCorn.PuzzleTest do
  use ExUnit.Case
  doctest FoxGooseBagOfCorn.Puzzle
  import FoxGooseBagOfCorn.Puzzle

  moves = [
    {":fox, :goose at right",[], [:boat, :you, :corn], [:fox, :goose], :false},
    {":corn, :goose at right",[], [:boat, :you, :fox], [:corn, :goose], :false},
    {"not human at right party for fox",[], [:boat, :you], [:corn, :fox, :goose], :false},
    {"everything ok at right",[], [:boat, :you, :goose], [:corn, :fox], :true},
    {":fox, :goose at left",[:fox, :goose], [:boat, :you, :corn], [], :false},
    {":corn, :goose at left",[:corn, :goose], [:boat, :you, :fox], [], :false},
    {"no human at left party for fox",[:corn, :fox, :goose], [:boat, :you], [], :false},
    {"everything ok at left",[:corn, :fox], [:boat, :you, :goose], [], :true},
    {"boat overload", [:corn], [:boat, :you, :fox, :goose], [], :false}
  ]

  for {p, l, c, r, is_ok?} <- moves do
    @prove p
    @left l
    @center c
    @right r
    @status is_ok?


    test "The moveset condition #{@prove} is OK? #{@status}" do
      # Change test implementation
      assert FoxGooseBagOfCorn.Puzzle.is_valid([@left,@center,@right]) == @status
    end
  end

  def validate_move(new_step, prev_step) do
    diff1 = Set.difference(prev_step, new_step)
    diff2 = Set.difference(new_step, prev_step)
    diffs = Set.union(diff1, diff2)
    diff_num = Set.size(diffs)
    assert 3 > diff_num

    if diff_num > 0 do
      assert Set.member?(diffs, :you)
    end

    new_step
  end

  def assert_equal_list_of_sets(expected, calculated) do
    assert length(expected) == length(calculated)

    Enum.zip(expected, calculated)
    |> Enum.each(fn {exp, calc} ->
      assert Set.equal?(exp, calc)
    end)
  end

  def nth_column(mtx, n), do: mtx |> Enum.map(&Enum.at(&1, n))

  setup_all do
    plan = river_crossing_plan |> Enum.map(&step_to_sets/1)
    left_bank = plan |> nth_column(0)
    right_bank = plan |> nth_column(2)
    {:ok, plan: plan, left_bank: left_bank, right_bank: right_bank}
  end

  test "you begin with the fox, goose and corn on one side of the river", %{plan: plan} do
    expected = [~H":you :fox :goose :corn", ~H":boat", ~H""]
    calculated = plan |> List.first()
    assert_equal_list_of_sets(expected, calculated)
  end

  test "you end with the fox, goose and corn on one side of the river", %{plan: plan} do
    expected = [~H"", ~H":boat", ~H":you :fox :goose :corn"]
    calculated = plan |> List.last()
    assert_equal_list_of_sets(expected, calculated)
  end

  test "the fox and the goose should never be left alone together", %{
    left_bank: left,
    right_bank: right
  } do
    assert (left ++ right)
           |> Enum.filter(&Set.equal?(~H":fox :goose", &1))
           |> Enum.empty?()
  end

  test "the goose and the corn should never be left alone together", %{
    left_bank: left,
    right_bank: right
  } do
    assert (left ++ right)
           |> Enum.filter(&Set.equal?(~H":goose :corn", &1))
           |> Enum.empty?()
  end

  test "The boat can carry only you plus one other", %{plan: plan} do
    assert plan
           |> nth_column(1)
           |> Enum.filter(&(Set.size(&1) > 3))
           |> Enum.empty?()
  end

  test "Moves are valid", %{plan: plan} do
    0..2
    |> Enum.each(fn idx ->
      plan
      |> nth_column(idx)
      |> Enum.reduce(&validate_move/2)
    end)
  end

  test "Possibilities move " do
    assert FoxGooseBagOfCorn.Puzzle.move([[:fox, :goose, :corn, :you], [:boat], []],
             from: :left,
             to: :center
           ) == [
             [[:goose, :corn], [:boat, :you, :fox], []],
             [[:fox, :corn], [:boat, :you, :goose], []],
             [[:fox, :goose], [:boat, :you, :corn], []],
             [[:fox, :goose, :corn], [:boat, :you], []]
           ]
  end



  test "Moves left to boat" do
    assert FoxGooseBagOfCorn.Puzzle.move([[:fox, :corn, :you], [:boat], [:goose]],
             from: :left,
             to: :center
           ) == [
             [[:corn], [:boat, :you, :fox], [:goose]],
             [[:fox], [:boat, :you, :corn], [:goose]],
             [[:fox, :corn], [:boat, :you], [:goose]]
           ]
  end

  test "Moves right to boat" do
    assert FoxGooseBagOfCorn.Puzzle.move([[:goose, :you], [:boat], [:corn, :fox]],
             from: :right,
             to: :center
           ) == [
             [[:goose, :you], [:boat, :you, :corn], [:fox]],
             [[:goose, :you], [:boat, :you, :fox], [:corn]]
           ]
  end

  test "Movement boat to right " do
    assert FoxGooseBagOfCorn.Puzzle.move([[:corn, :fox], [:boat, :you, :goose], []],
             from: :center,
             to: :right
           ) == [
             [[:corn, :fox], [:boat, :goose], [:you]],
             [[:corn, :fox], [:boat], [:you, :goose]]
           ]
  end

  test "Movement boat to left" do
    assert FoxGooseBagOfCorn.Puzzle.move([[:goose], [:boat, :you], [:corn, :fox]],
             from: :center,
             to: :left
           ) ==
             [[[:goose, :you], [:boat], [:corn, :fox]]]
  end
end
