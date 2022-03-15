defmodule CardGameWar.Game do

  # feel free to use these cards or use your own data structure"
  def suits, do: [:spade, :club, :diamond, :heart]
  def ranks, do: [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  def cards do
    for suit <- suits,
        rank <- ranks do
      {suit, rank}
    end
  end

  def mazos do
    cards() |> Enum.shuffle() |> Enum.chunk_every(26)
  end

  def play() do
    [j1 | [j2]] = mazos()
    war(j1, j2, 1)
  end

  def war([], _, _t) do
    IO.puts("\n")
    {:Ganador, :J2}
  end
  def war(_, [], _t) do
    IO.puts("\n")
    {:Ganador, :J1}
  end
  def war(j1, j2, t) do

    [h1|t1] = j1
    [h2|t2] = j2
    IO.puts("\n     turno" <> to_string(t))
    IO.puts("\njugador1:    mazo:" <> (j1|> length() |> to_string()))
    x = mapp(IO.inspect(h1))
    IO.puts("jugador2:      mazo:"<>  (j2|> length() |> to_string()))
    y = mapp(IO.inspect(h2))

    palo1 = palos(h1)
    palo2 = palos(h2)

    cond do
      x > y ->
        IO.puts("EL JUGADOR 1 GANA LA RONDA")
        l = t1++[h1]++[h2]
        war(l,t2, t+1)
      x < y ->
        IO.puts("EL JUGADOR 2 GANA LA RONDA")
        l = t2++[h1]++[h2]
        war(t1,l, t+1)
      true ->

        cond do
          palo1 > palo2 ->
            IO.puts("EL JUGADOR 1 GANA LA RONDA")
            l = t1++[h1]++[h2]
            war(l,t2, t+1)
          true ->
            IO.puts("EL JUGADOR 2 GANA LA RONDA")
            l = t2++[h1]++[h2]
            war(t1,l, t+1)
        end
    end
  end

  def mapp({_, valor }) do
      x = valor
    cond do
      x  == :ace ->  14
      x == :king -> 13
      x == :queen -> 12
      x == :jack -> 11
      true -> valor
    end
  end

  def palos({palo,_}) do
    cond do
      palo == :heart -> 4
      palo == :diamond -> 3
      palo == :club -> 2
      true -> 1
    end
  end
end
