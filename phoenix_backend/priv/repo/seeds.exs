# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixBackend.Repo.insert!(%PhoenixBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixBackend.Repo
alias PhoenixBackend.Accounts.User
alias PhoenixBackend.Content.Post

if is_nil(Repo.get(User, 1)) do
  1..10
  |> Enum.each(fn user_number ->
    user = Repo.insert!(%User{name: "User#{user_number}"})
    1..(user_number * user_number)
    |> Enum.each(fn post_number ->
      Repo.insert!(%Post{user_id: user.id, title: "Post #{post_number} by #{user.name}"})
    end)
  end)
end
