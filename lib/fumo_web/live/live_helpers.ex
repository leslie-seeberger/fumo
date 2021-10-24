defmodule FumoWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `FumoWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, FumoWeb.CardLive.FormComponent,
        id: @card.id || :new,
        action: @live_action,
        card: @card,
        return_to: Routes.deck_card_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(FumoWeb.ModalComponent, modal_opts)
  end
end
