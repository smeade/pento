defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog

  def time() do
    DateTime.utc_now |> to_string
  end

  # TRACE_3: mount/3
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # TRACE_4: handle_params
  # with id = product's id
  # :id from path in router.ex

  # TRACE_8: handle_params after live_action = :edit
  #          re-renders show.html.heex with product loaded into @product
  #          page_title set to "Edit Product"
  #          and live_action set to :edit
  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message, "Hey You!")
     |> assign(:product, Catalog.get_product!(id))}
  end

  # TRACE_5: render /product/show.html.heex
  #
  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
