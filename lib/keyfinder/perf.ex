defmodule Keyfinder.Perf do
  alias Keyfinder.Kv

  def collect_results() do
    for size <- [
          1000,
          5000,
          10000,
          50000,
          100_000,
          200_000,
          500_000,
          800_000,
          1_000_000,
          2_000_000
        ] do
      IO.puts("Testing for size #{size}...")
      %{size: size, dict: test_dict(size), map: test_map(size)}
    end
  end

  def test_dict(max) do
    IO.puts("Starting custom implementation test...")

    uuid_list =
      for _a <- 1..max do
        Ecto.UUID.generate()
      end

    kv = Enum.map(uuid_list, fn uuid -> {uuid, to_string(:rand.uniform())} end)

    IO.puts("Seed generated")
    IO.puts("Test lookup for #{div(max, 1000)} existing elements")

    results =
      for _x <- 1..div(max, 1000) do
        timer = Timber.start_timer()
        Kv.lookup(kv, Enum.random(uuid_list))
        Timber.Timer.duration_ms(timer, 2)
      end
      |> Enum.sort()

    IO.puts("Results for custom implementation:")
    res = print_results(results)

    IO.puts("Test lookup of nonexisting element...")
    timer = Timber.start_timer()
    Kv.lookup(kv, Ecto.UUID.generate())
    IO.puts("#{Timber.Timer.duration_ms(timer, 2)} ms")
    res
  end

  def test_map(max) do
    IO.puts("Starting map implementation test...")

    uuid_list =
      for _a <- 1..max do
        Ecto.UUID.generate()
      end

    map = build_map(uuid_list, %{})

    IO.puts("Seed generated")
    IO.puts("Test lookup for #{div(max, 1000)} existing elements")

    results =
      for _x <- 1..div(max, 1000) do
        timer = Timber.start_timer()
        Map.get(map, Enum.random(uuid_list))
        Timber.Timer.duration_ms(timer, 2)
      end
      |> Enum.sort()

    IO.puts("Results for map implementation:")
    res = print_results(results)

    IO.puts("Test lookup of nonexisting element...")
    timer = Timber.start_timer()
    Map.get(map, Ecto.UUID.generate())
    IO.puts("#{Timber.Timer.duration_ms(timer, 2)} ms")
    res
  end

  defp print_results(results) do
    res = %{
      min: hd(results),
      avg: Float.round(Enum.sum(results) / length(results), 2),
      max: List.last(results)
    }

    IO.puts("Min time #{res.min} ms\nMax time #{res.max} ms\nAvg time #{res.avg} ms")
    res
  end

  defp build_map([uuid | tail], map) do
    build_map(tail, Map.put(map, uuid, :rand.uniform()))
  end

  defp build_map([], map), do: map
end
