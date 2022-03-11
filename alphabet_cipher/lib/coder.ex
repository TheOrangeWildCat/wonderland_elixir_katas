defmodule AlphabetCipher.Coder do
  def abecedario() do
    'abcdefghijklmnopqrstuvwxyz' |> Enum.with_index
  end

  def encode(keyword, message) do
    keyword = keyword
    |> String.downcase()
    |> String.duplicate(div(String.length(message),String.length(keyword))+1)
    |> to_charlist()

    message = message
    |> String.downcase()
    |> to_charlist()

    Enum.zip_with(message, keyword, fn(m,k) ->
      {_ , mindx} = List.keyfind!(abecedario(),m,0)
      {_ , kindx} = List.keyfind!(abecedario(),k,0)
      cond do
        mindx + kindx >= length(abecedario()) ->
          {char, _}= List.keyfind(abecedario(), mindx + kindx - length(abecedario()), 1)
          char
        true ->
          {char, _} = List.keyfind(abecedario(), mindx + kindx, 1)
          char
      end
    end) |> to_string()


  end

  def decode(keyword, message) do
    keyword = keyword
    |> String.downcase()
    |> String.duplicate(div(String.length(message),String.length(keyword))+1)
    |> to_charlist()
    message = message
    |> String.downcase()
    |> to_charlist()

    Enum.zip_with(message, keyword, fn(m,k) ->
      {_ , mindx} = List.keyfind!(abecedario(),m,0)
      {_ , kindx} = List.keyfind!(abecedario(),k,0)
      cond do
        mindx - kindx < 0 ->
          {char, _}= List.keyfind(abecedario(), mindx + length(abecedario()) - kindx, 1)
          char
        true ->
          {char, _} = List.keyfind(abecedario(), mindx - kindx, 1)
          char
      end
    end) |> to_string()
  end

  def decipher(cipher, message) do
    cipherC = cipher
    |> String.downcase()
    |> to_charlist()

    messageC = message
    |> String.downcase()
    |> to_charlist()

    Enum.zip_with(messageC, cipherC, fn(m,c) ->
      {_ , mindx} = List.keyfind!(abecedario(),m,0)
      {_ , cindx} = List.keyfind!(abecedario(),c,0)
      cond do
        cindx - mindx < 0 ->
          {char, _}= List.keyfind(abecedario(), cindx + length(abecedario()) - mindx, 1)
          char
        true ->
          {char, _} = List.keyfind(abecedario(), cindx - mindx, 1)
          char
      end
    end) |> Enum.reduce("", fn(x,acc)->
      cond do
        String.length(acc) == 0 ->
          acc <> to_string([x])
        encode(acc, message) == cipher ->
          acc
        true ->
          acc <> to_string([x])
      end
    end)

  end
end


#iex(61)> AlphabetCipher.Coder.encode("mano","corazon")
#"ooeoloa"
