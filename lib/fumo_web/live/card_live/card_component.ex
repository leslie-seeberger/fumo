defmodule FumoWeb.CardComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
      <div class="card-wrapper" phx-hook="Card" id="<%= @id %>">
        <div class="card p-2"  >
          <div class="card-inner card-front">
            <p><%= @card.front %></p>
          </div>
          <div class="card-inner card-back">
            <p><%= @card.back %></p>
          </div>
        </div>
      </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
