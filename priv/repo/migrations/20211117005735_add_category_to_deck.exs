defmodule Fumo.Repo.Migrations.AddCategoryToDeck do
  use Ecto.Migration
  import Ecto.Query
  alias Fumo.Repo
  alias Fumo.FlashCards.{Deck, Category}

  def up
   do

    alter table(:decks) do
      add :category_id, references(:categories, on_delete: :nothing)
    end

    flush()

    drop_if_exists constraint("decks", "decks_category_id_fkey")

    category_id = Category
      |> where([c], c.name == "Misc")
      |> select([c], c.id)
      |> Repo.one()

    Deck
    |> where([d], is_nil(d.category_id))
    |> Repo.update_all(set: [category_id: category_id])

    alter table(:decks) do
      modify :category_id, references(:categories), null: false
    end

    create index(:decks, [:category_id])
  end

  def down do
    drop_if_exists constraint("decks", "decks_category_id_fkey")

    alter table(:decks) do
      remove :category_id
    end
  end
end
