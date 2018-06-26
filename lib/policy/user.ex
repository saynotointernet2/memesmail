defmodule Memesmail.Policy.User do
  @moduledoc """
  Establishing policies for User functionality
  """

  alias Memesmail.Model.Types, as: T

  @spec init_login(T.user) :: :ok | {:error, String.t}
  def init_login(_user) do
    :ok
  end

  @spec login(T.user, T.session_token) :: :ok | {:error, String.t}
  def login(_user, _session_token) do
    :ok
  end

  @spec logout(T.user, T.session_token) :: :ok | {:error, String.t}
  def logout(_user, _session_token) do
    :ok
  end

  @spec register_user(T.user, T.login_token, binary, T.root_object) :: :ok | {:error, String.t}
  def register_user(user, _login_token, register_token, _root_object) do
    with :ok <- user_name_valid(user),
         :ok <- register_token_valid(register_token)
      do
      :ok
    else
      err -> err
    end
  end

  @spec register_token_valid(binary) :: :ok | {:error, String.t}
  defp register_token_valid(_register_token) do
    :ok
  end

  @spec user_name_valid(T.user) :: :ok | {:error, String.t}
  defp user_name_valid(_user) do
    :ok
  end

end
