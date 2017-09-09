defmodule PgStore.UserClient do
  @moduledoc """
  Define the client data interface behavior
  """

  @doc """
  Get user auth token
  """
  @spec get_user_login_token(pid, binary) :: {atom, binary}
  def get_user_login_token(pid, user) do
  #TODO use prepared statements to avoid sqlinjections
    result = Postgrex.query!(pid, "SELECT LOGIN_TOKEN FROM MM_USER WHERE USER_IDENTIFIER = '" <> user <> "';", [])
    cond do
      String.upcase(hd(result.columns)) != "AUTH_TOKEN" ->
        {:error, "invalid table"}
      result.num_rows == 0 ->
        {:error, "could not find"}
      result.num_rows != 1 ->
        {:error, "multiple results"}
      true ->
        {:ok, hd(hd(result.rows))}
    end
  end

  @doc """
  Create new user
  """
  @spec create_new_user(pid, {binary, binary, binary}) :: {atom, binary}
  def create_new_user(pid, {user_id, login_token, storage_root}) do
  #TODO use prepared statements to avoid sqlinjections
    result = Postgrex.query!(
      pid,
      "INSERT INTO MM_USER (user_identifier, login_token, storage_root) VALUES ('" <>
      user_id <> "', '" <>
      login_token <> "', '" <>
      storage_root <> "')",
      [])

    cond do
      result.num_rows != 1 ->
        {:error, "failed to insert one row into user table"}
      true ->
        {:ok, "created user " <> user_id}
    end
  end

end