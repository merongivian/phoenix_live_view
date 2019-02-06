defmodule Phoenix.LiveViewTest.View do
  @moduledoc false
  alias Phoenix.LiveViewTest.View

  defstruct token: nil,
            module: nil,
            endpoint: nil,
            pid: :static,
            proxy: nil,
            topic: nil,
            ref: nil,
            rendered: nil,
            children: MapSet.new()

  def build(attrs) do
    topic = "phx-" <> Base.encode64(:crypto.strong_rand_bytes(8))
    struct(__MODULE__, Keyword.put_new(attrs, :topic, topic))
  end

  def build_child(%View{} = parent, attrs) do
    build(Keyword.merge(attrs, proxy: parent.proxy, endpoint: parent.endpoint))
  end

  def put_child(%View{} = parent, session) do
    %View{parent | children: MapSet.put(parent.children, session)}
  end

  def drop_child(%View{} = parent, session) do
    %View{parent | children: MapSet.delete(parent.children, session)}
  end

  def prune_children(%View{} = parent) do
    %View{parent | children: MapSet.new()}
  end

  def removed_children(%View{} = parent, children_before) do
    MapSet.difference(children_before, parent.children)
  end

  def connected?(%View{pid: pid}) when is_pid(pid), do: true
  def connected?(%View{pid: :static}), do: false
end
