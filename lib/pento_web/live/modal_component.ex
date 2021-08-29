defmodule PentoWeb.ModalComponent do
  # Components are defined by using Phoenix.LiveComponent and
  # are used by calling Phoenix.LiveView.Helpers.live_component/3 in a parent LiveView.
  use PentoWeb, :live_component

  # Components run inside the LiveView process,
  # but they have their own state, event handling and life-cycle.
  # That's why they are also called stateful components.
  # The simplest component only needs to define a render/1 function:

  # TRACE_14: mount the live_modal component

  # The default mount/1 function just passes the socket through, unchanged.

  # TRACE_15: run default update/2 function

  # The default update/2 function merely takes the assigns we call live_component/3
  # with and passes them to the socket.

  # We don’t need to implement them ourselves unless we want to customize this behavior.

  # Three ingredients to event management in LiveViews
  #
  # First, we add a LiveView DOM Element binding, or LiveView binding, (phx-capture-click="close")
  # to a given HTML element. LiveView supports a number of such bindings that send events over
  # the WebSocket to the live view when a specified client interaction, like a button click or
  # form submit, occurs.
  #
  # Then, we specify a target for that LiveView event by adding a phx-target attribute (phx-target={@myself})
  # to the DOM element we’ve bound the event to. This instructs LiveView where to send the event:
  # to the parent LiveView, the current component, or to another component entirely.
  #
  # Lastly, we implement a handle_event/3 callback (def handle_event("close", _, socket)
  # that matches the name of the event in the targeted live view or component.

  # TRACE_16: render the live_modal component
  #           which calls live_component/3 with @component == "PentoWeb.ProductLive.FormComponent"
  #                                         and @opts passed through
  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>

      <div class="phx-modal-content">
        <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close" %>
        <%= live_component @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
