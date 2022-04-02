defmodule Doublets.Solver do
  @words "./resources/words.txt"
         |> File.stream!()
         |> Enum.to_list()
         |> Enum.map(&String.trim(&1))

  def doublets(word1, word2)
      when word1 in @words and
             word2 in @words do
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
    IO.puts("llega :")
    IO.inspect(acum)
    IO.puts("Se borra del dic:")
    nWords = words |> List.delete(word1)

    next =
      Enum.reduce_while(nWords, "", fn x, acc ->
        a = Simetric.Levenshtein.compare(x, word1)

        if a == 1 do
          {:halt, x}
        else
          {:cont, acc}
        end
      end)

    IO.puts("salio ")
    IO.inspect(next)

    cond do
      next == word2 ->
        [next | acum] |> Enum.reverse()

      next == "" and length(acum) == 0 ->
        :no_match

      next == "" ->
        [_ | t] = acum
        [h | _] = t
        IO.puts("mejor me regreso")
        IO.inspect(h)
        comparar(h, word2, nWords, t)

      true ->
        comparar(next, word2, nWords, [next | acum])
    end
  end
end
