defmodule Doublets.SolverTest do
  use ExUnit.Case
  import Doublets.Solver

  test "with word links found" do
    assert ["head", "heal", "teal", "tell", "tall", "tail"] ==
             doublets("head", "tail")

    assert ["door", "boor", "book", "look", "lock"] ==
             doublets("door", "lock")

    assert ["bank", "bonk", "book", "look", "loon", "loan"] ==
             doublets("bank", "loan")

    assert ["wheat", "cheat", "cheap", "cheep", "creep", "creed", "breed", "bread"] ==
             doublets("wheat", "bread")
  end

  test "with no word links found" do
    assert [] == doublets("ye", "freezer")
  end

  test "prueba de find_solution" do
    assert Doublets.Solver.find_solution([["agua", "doce", "diez"], ["uno", "dos"]], "dos") ==
             ["uno", "dos"]

    assert Doublets.Solver.find_solution(
             [["agua", "doce", "diez"], ["uno", "dos"], ["baño", "cocina", "camisa"]],
             "diez"
           ) ==
             ["agua", "doce", "diez"]
  end

  test "prueba complete_seq_variants" do
    assert Doublets.Solver.complete_seq_variants(["wheat", "cheat"]) ==
             [["wheat", "cheat", "cheap"]]

    assert Doublets.Solver.complete_seq_variants(["book", "look"]) ==
             [["book", "look", "lock"], ["book", "look", "loon"]]
  end

  test "same length words" do
    assert Doublets.Solver.same_length_words("book") ==
             [
               "muta",
               "task",
               "quat",
               "head",
               "heal",
               "teal",
               "tell",
               "tall",
               "tail",
               "door",
               "boor",
               "look",
               "lock",
               "bank",
               "bonk",
               "loon",
               "loan"
             ]

    assert Doublets.Solver.same_length_words("allanitic") ==
             [
               "sharewort",
               "emphysema",
               "tomatillo",
               "appentice",
               "vanjarrah",
               "rapturous",
               "rotascope",
               "staringly",
               "bootyless",
               "facetious",
               "hugeously",
               "chantress",
               "halurgist",
               "artichoke",
               "mesoarial",
               "urethylan",
               "beachless"
             ]
  end

  test "distance words" do
    assert Doublets.Solver.distance("gallinas", "gelatina") == 6
    assert Doublets.Solver.distance("halurgist", "hugeously") == 8
    assert Doublets.Solver.distance("animalito", "animalita") == 1
  end
end
