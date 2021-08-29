defmodule PentoWeb.ProductLive.FormComponent do

  ################################################################
  # STEP_3:
  # When live views become too complex or repetitive, you can break
  # off components. A LiveComponent compartmentalizes state, HTML
  # markup, and event processing for a small part of a live view.
  ################################################################
  use PentoWeb, :live_component

  alias Pento.Catalog

  # TRACE_17: mount()
  #           Again, Components run inside the LiveView process,
  #           but they have their own state, event handling and life-cycle.
  #           So the behaviour calls FormComponent's mount() here just as it called
  #           PentoWeb.ModalComponent mount() (TRACE_14) and
  #           PentoWeb.ProductLive.Show's mount() (TRACE_3).

  # The default mount/1 function just passes the socket through, unchanged.

  # TRACE_18: update()
  #           Again, Components run inside the LiveView process,
  #           but they have their own state, event handling and life-cycle.
  #           So the behaviour calls FormComponent's update() here just as it called
  #           PentoWeb.ModalComponent update() (TRACE_15).
  #           PentoWeb.ProductLive.Show does not have an update() function because
  #           it is not a LiveComponent.

  # The default update/2 function merely takes the assigns we call live_component/3
  # with and passes them to the socket.

  # We don’t need to implement them ourselves unless we want to customize this behavior.
  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  # TRACE_19: render() form_component.html.heex

  # TRACE_21: handle "validate" event
  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      # If no action has been applied to the changeset or action was set to :ignore, no errors are shown
      # See: https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#module-a-note-on-errors
      |> Map.put(:action, :validate)

    {:noreply,
      socket
      |> assign(:changeset, changeset)
    }
  end

  # TRACE_22: handle "save" event
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
