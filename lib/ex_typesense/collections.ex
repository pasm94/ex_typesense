defmodule ExTypesense.Collections do
  @moduledoc """
  Documentation for `Typesense`.
  """
  use Tesla

  @base_url Application.get_env(:ex_typesense, __MODULE__)[:base_url]
  @port Application.get_env(:ex_typesense, __MODULE__)[:port]
  @api_key Application.get_env(:ex_typesense, __MODULE__)[:api_key]

  @complete_url "#{@base_url}:#{to_string(@port)}"

  plug(Tesla.Middleware.BaseUrl, @complete_url)

  plug(Tesla.Middleware.Headers, [
    {"User-Agent", "Tesla"},
    {"X-TYPESENSE-API-KEY", @api_key}
  ])

  plug(Tesla.Middleware.JSON)

  @doc """
  Create a collection.

  ## Examples
  iex> schema = %{
    name: "creators",
    fields: [
      %{name: "name", type: "string"},
      %{name: "subscribers", type: "int32"},
    ],
    default_sorting_field: "subscribers"
  }
  iex> Typesense.Collections.create(schema)
  {:ok, collection}
  """
  def create(schema) do
    post("/collections", schema)
  end

  @doc """
  Retrieve all collections.

  ## Examples
  iex> Typesense.Collections.retrieve()
  [%{}, ...]
  """
  def retrieve do
    get("/collections")
  end

  @doc """
  Drop a collection.

  ## Examples
  iex> Typesense.Collections.drop(collection_id)
  {:ok, _collection}
  """
  def drop(collection) do
    delete("/collections/#{collection}")
  end

  @doc """
  Search a collection.

  ## Examples
  iex> Typesense.Collections.search(collection, query_params)
  [%{}, ...]
  """
  def search(collection, query_params) do
    get("/collections/#{collection}/documents/search", query: query_params)
  end
end
