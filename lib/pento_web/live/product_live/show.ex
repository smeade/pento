defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog

  def time() do
    DateTime.utc_now |> to_string
  end

  # TRACE_3: mount/3
  @impl true
  def mount(_params, _session, socket) do
    IO.inspect("TRACE_2: PentoWeb.ProductLive.Show#mount(_params, _session, socket)")
    # IO.inspect("TRACE_3")
    {:ok, socket}
  end

  # TRACE_4: handle_params
  # with id = product's id
  # :id from path in router.ex

  # TRACE_8: handle_params after live_action = :edit
  #          re-renders show.html.heex with product loaded into @product
  #          page_title set to "Edit Product"
  #          and live_action set to :edit

  # live_patch/2 Generates a link that will patch the current LiveView.
  # When navigating to the current LiveView, Phoenix.LiveView.handle_params/3
  # is immediately invoked to handle the change of params and URL state.
  # Then the new state is pushed to the client, without reloading the whole
  # page while also maintaining the current scroll position.
  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    trace(socket.assigns.live_action)
    IO.inspect(socket.assigns.live_action)
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
  defp page_title(:editx), do: "Editx Product"

  defp trace(:show) do
    IO.inspect("TRACE_4: PentoWeb.ProductLive.Show#handle_params(%{'id' => id}, _, socket):show ")
  end

  defp trace(:edit) do
    IO.inspect("TRACE_7: PentoWeb.ProductLive.Show#handle_params(%{'id' => id}, _, socket):edit ")
    # IO.inspect("TRACE_8")
  end

  defp trace(:editx) do
    IO.inspect("TRACE_7: PentoWeb.ProductLive.Show#handle_params(%{'id' => id}, _, socket):editx ")
    # IO.inspect("TRACE_8")
  end
end
