defmodule CardGameWar.GameTest do
  use ExUnit.Case

  test "the highest rank wins the cards in the round" do
    assert {:Ganador, :J2} ==
      CardGameWar.Game.war([{:spade, 4}],[{:spade, 9}],1)
  end

  test "queens are higher rank than jacks" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:club, :queen}],[{:spade, :jack}], 1)
  end

  test "kings are higher rank than queens" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:heart, :king}],[{:heart, :queen}], 1)
  end

  test "aces are higher rank than kings" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:spade, :ace}],[{:spade, :king}], 1)
  end

  test "if the ranks are equal, clubs beat spades" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:club, :ace}],[{:spade, :ace}], 1)
  end

  test "if the ranks are equal, diamonds beat clubs" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:diamond, 2}],[{:club, 2}],1)
  end

  test "if the ranks are equal, hearts beat diamonds" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:heart, :ace}],[{:diamond, :ace}], 1)
  end

  test "the player loses when they run out of cards" do
    assert {:Ganador, :J1} ==
      CardGameWar.Game.war([{:spade, :ace}],[], 1)
  end

end
