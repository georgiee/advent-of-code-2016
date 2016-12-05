defmodule Day05 do
    def hash(id, salt) do
        :crypto.hash(:md5, to_string(id) <> to_string(salt)) |> Base.encode16
    end

    def value_with_5_zeros(value) do
        prefix = "00000"
        String.starts_with? value, prefix
    end


    def find(id, index, keys) when index <= 100.0e6 and length(keys) < 8  do
        if rem(index, 100000) == 0 do
            IO.puts("processing segment #{index}")
        end

        hash = Day05.hash(id, index)
        found = value_with_5_zeros(hash)

        if found do
            key = String.slice(hash, 5, 1)
            IO.puts "found hash #{hash} #{index} -- key count: #{length(keys) + 1}"
            Day05.find(id, index + 1, keys ++ [ key ])
        else
            Day05.find(id, index + 1, keys)
        end

    end

    def find(id, index, keys) do
        if length(keys) < 8 do
            IO.puts "Aborted search, couldn't find key as we reached the max search depth. Aborted at #{index} with current key being #{keys}"
        else
            IO.puts "DONE! Found key for  #{id}: #{keys}"
        end
    end
end

defmodule Day05V2 do
    def hash(id, salt) do
        :crypto.hash(:md5, to_string(id) <> to_string(salt)) |> Base.encode16
    end

    def value_with_5_zeros(value) do
        prefix = "00000"
        String.starts_with? value, prefix
    end


    def find(id, index, keys) when (index <= 100.0e6)  do
        if rem(index, 1000000) == 0 do
            IO.puts("processing segment #{index}")
        end

        hash = Day05.hash(id, index)
        found = value_with_5_zeros(hash)

        if found do
            {position, _} = Integer.parse(String.slice(hash, 5, 1),16)
            key = String.downcase(String.slice(hash, 6, 1))

            if Enum.at(keys, position) == "_" do
                keys = List.replace_at(keys, position, key)
            end
            done = Enum.member?(keys, "_") == false

            IO.puts "found hash #{done} #{hash} #{index} -- #{key}@#{position} key count: #{length(keys) + 1}"
            IO.puts("#{List.to_string(keys)}")

            if done do
                Day05V2.find(id, keys)
            else
                Day05V2.find(id, index + 1, keys)
            end
        else
            Day05V2.find(id, index + 1, keys)
        end

    end

    def find(id, index, keys) do
        IO.puts "Aborted search, couldn't find key as we reached the max search depth. Aborted at #{index} with current key being #{List.to_string(keys)}"
    end

    def find(id, keys) do
        IO.puts "DONE! Found key for  #{id}: #{List.to_string(keys)}"
    end
end
{:one, :two, :three, :four, :five, :six, :seven, :eight}
#Day05.find("abc", 0, [])

#Day05V2.find("abc", 3231929, (Enum.map 1..8, fn _ -> "_" end) )
Day05V2.find("ffykfhsq", 0, (Enum.map 1..8, fn _ -> "_" end) )

