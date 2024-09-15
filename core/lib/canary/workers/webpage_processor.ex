defmodule Canary.Workers.WebpageProcessor do
  use Oban.Worker, queue: :webpage_processor, max_attempts: 1

  alias Canary.Sources.Event
  alias Canary.Sources.Source
  alias Canary.Sources.Webpage

  @impl true
  def perform(%Oban.Job{args: %{"source_id" => id}}) do
    case Ash.get(Source, id) do
      {:error, _} -> :ok
      {:ok, source} -> process(source)
    end
  end

  defp process(%Source{id: source_id} = source) do
    Event.create(source_id, %Event.Meta{
      level: :info,
      message: "webpage fetcher started"
    })

    with {:ok, incomings} = Webpage.Fetcher.run(source),
         :ok <- Webpage.Syncer.run(source_id, incomings) do
      Event.create(source_id, %Event.Meta{
        level: :info,
        message: "webpage fetcher ended"
      })

      source
      |> Ash.Changeset.for_update(:post_fetch, %{})
      |> Ash.update()
    end
  end
end
