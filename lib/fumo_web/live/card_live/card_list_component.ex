defmodule FumoWeb.CardListComponent do
  alias FumoWeb.CardComponent
  use FumoWeb, :live_view

  @impl true
  def mount(_params, %{"cards" => cards}, socket) do

    {:ok, assign(socket, cards: cards, current: 0, length: length(cards))}
  end

  @impl true
  def render(assigns) do
    card = Enum.at(assigns.cards, assigns.current)
    ~L"""
      <div
      class="flex items-center justify-center"
      >
        <%= live_component(@socket, CardComponent, card: card, id: "current_card") %>
      </div>
      <div class=" flex gap-4 p-4 items-center">
        <button class="btn" <%= if @current == 0, do: "disabled=disabled" %> phx-click="prev-card">Previous</button>
        <button class="btn" <%= if @current == (@length - 1), do: "disabled=disabled" %>  phx-click="next-card">Next</button>
      </div>

    """
  end

  @impl true
  def handle_event("prev-card", _params, socket) do
    current = Enum.max([0, socket.assigns.current - 1])
    socket =
      assign(socket, current: current)
    {:noreply, push_event(socket, "prev-card", %{})}
  end

  def handle_event("next-card", _params, socket) do

    current =
      Enum.min([socket.assigns.current + 1, socket.assigns.length - 1])
    socket =
      assign(socket, current: current)
    {:noreply, push_event(socket, "next-card", %{})}
  end

end
