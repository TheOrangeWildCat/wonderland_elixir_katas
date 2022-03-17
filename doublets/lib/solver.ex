defmodule Doublets.Solver do

  @words "./resources/words.txt"
    |> File.stream!()
    |> Enum.to_list()
    |> Enum.map(&String.trim(&1))
  # def words do
  #   "./resources/words.txt"
  #   |> File.stream!()
  #   |> Enum.to_list()
  #   |> Enum.map(&String.trim(&1))
  # end

  def doublets(word1, word2) do
    cond do
      String.length(word1) != String.length(word2) ->
        []

      word1 == word2 ->
        [word1]


      true ->
        comparar(word1, word2, @words, [word1])
    end
  end

  def comparar(word1, word2, words, acum) do
    wLength = String.length(word2)
    nWords = words |> List.delete(word1|> IO.inspect())

    next =
      Enum.reduce(nWords, [], fn x, acc ->
        a = Simetric.Levenshtein.compare(x, word1)

        if a == 1 do
          [x | acc]
        else
          acc
        end
      end) |> to_string()


      if next == word2 do
        [next | acum]|> Enum.reverse()
      else
        acum
      # comparar(next, word2, nWords, [next|acum])


    end
  end
end
