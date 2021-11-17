# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fumo.Repo.insert!(%Fumo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fumo.FlashCards

for category <- ["Languages", "Computer Science", "Sports", "Geography", "Games", "Math","Science",
                "Pop Culture", "Arts", "Financial", "History", "Culture", "Misc"] do
    FlashCards.create_category(%{name: category})
end
