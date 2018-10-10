defmodule PhoenixBackendWeb.UserView do
  use PhoenixBackendWeb, :view

  alias PhoenixBackend.Content.Post
  alias PhoenixBackend.Repo

  alias PhoenixBackendWeb.UserView

  import Ecto.Query

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("index_n_plus_1.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_n_plus_1.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_n_plus_1.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_n_plus_1.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name}
  end

  # This code is terrible on purpose; don't judge me. 😅
  def render("user_n_plus_1.json", %{user: user}) do
    posts =
      user.id
      |> post_ids_for_user_query()
      |> Repo.all()
      |> Enum.map(fn post_id ->
        title =
          post_id
          |> post_title_query()
          |> Repo.one()

        %{id: post_id, title: title}
      end)

    %{
      id: user.id,
      name: user.name,
      posts: [posts]
    }
  end

  defp post_ids_for_user_query(user_id) do
    from p in Post,
    where: p.user_id == ^user_id,
    select: p.id
  end

  defp post_title_query(post_id) do
    from p in Post,
    where: p.id == ^post_id,
    select: p.title
  end
end
