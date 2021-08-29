defmodule PentoWeb.ProductLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Product

  def time() do
    DateTime.utc_now |> to_string
  end

  ################################################################
  # Entry point into our application
  # ->     live "/products", ProductLive.Index, :index
  # the LiveView behaviour calls mount/3, and then render/1.
  #
  #
  # STEP_2:
  # The live view puts data in the socket using mount/3
  # and handle_params/3, and then renders that data in a template
  # with the same name as the live view.
  ################################################################
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:greeting, "Welcome!!")
      |> assign(:products, list_products())
    }
  end

  ################################################################
  # There’s no explicit render/1 function defined
  # in the ProductLive.Index live view,
  # so our live view will render the template
  # in the index.html.leex file.
  ################################################################

  ################################################################
  # The mount/render and change management workflows make it easy
  # to reason about state management and help you find a home for
  # all of your CRUD code across just two live views.
  ################################################################

  ################################################################
  # LiveView's change management workflow—
  # -> the handle_params/3 function will be invoked for the
  #    linked LiveView with live_action assignment is populated
  #    as configured in router.ex and passed in
  #    ex: product_index_path(@socket, :edit, product)
  #        product_index_path(@socket, :new)
  # -> followed by the render/1 function.
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Catalog.list_products()
  end
end
