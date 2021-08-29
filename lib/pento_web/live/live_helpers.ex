defmodule PentoWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `PentoWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal PentoWeb.ProductLive.FormComponent,
        id: @product.id || :new,
        action: @live_action,
        product: @product,
        return_to: Routes.product_index_path(@socket, :index) %>
  """
  # TRACE_10: LiveHelper method to render modals
  def live_modal(component, opts) do
    # TRACE_11: component == "PentoWeb.ProductLive.FormComponent"
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    # TRACE_12: calls live_component with component == "PentoWeb.ModalComponent"
    #           and modal_opts passed through
    live_component(PentoWeb.ModalComponent, modal_opts)
  end
end
