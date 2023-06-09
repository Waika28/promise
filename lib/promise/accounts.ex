defmodule Promise.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Promise.Repo

  alias Promise.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_email_and_password(email, password) do
    email
    |> get_user_by_email()
    |> Argon2.check_pass(password)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def search_by_name(name, params \\ %{}) do
    User
    |> order_by([u],
      desc: fragment("SIMILARITY(? || ' ' || ?, ?)", u.first_name, u.last_name, ^name)
    )
    |> Flop.validate_and_run(params, for: User)
  end

  alias Promise.Accounts.Subscription

  def get_subscription(subject, object) do
    Subscription
    |> where([s], s.subject_id == ^subject.id and s.object_id == ^object.id)
    |> Repo.one!()
  end

  def subscribe(subject, object) do
    %Subscription{}
    |> Subscription.changeset(%{})
    |> Ecto.Changeset.put_assoc(:subject, subject)
    |> Ecto.Changeset.put_assoc(:object, object)
    |> Repo.insert()
  end

  def unsubscribe(subject, object) do
    Subscription
    |> where([s], s.subject_id == ^subject.id and s.object_id == ^object.id)
    |> Repo.one!()
    |> Repo.delete()
  end
end
