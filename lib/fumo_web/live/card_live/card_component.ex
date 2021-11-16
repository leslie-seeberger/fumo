defmodule FumoWeb.CardComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
      <div class="card-wrapper" phx-hook="Card" id="<%= @id %>" x-on:click="flip = !flip">
        <div class="card p-2" x-bind:class="flip ? 'flip' : ''"  >
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
