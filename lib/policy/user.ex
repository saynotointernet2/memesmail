defmodule Memesmail.Policy.User do
  @moduledoc """
  Establishing policies for User functionality
  """

  alias Memesmail.Model.Types, as: Types

  #  @callback init_login(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  #  @callback do_login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}
  #  @callback logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  #  @callback register_user(Types.user, Types.login_token, Types.root_object) :: :ok | {:error, String.t}

  @spec init_login(Types.user) :: :ok | {:error, String.t}
  def init_login(_user) :: :ok | {:error, String.t} do
    :ok
  end

  @spec do_login(Types.user, Types.session_token) :: :ok | {:error, String.t}
  def do_login(_user, _session_token) :: :ok | {:error, String.t} do
    :ok
  end

  @spec logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  def logout(_user, _session_token) :: :ok | {:error, String.t} do
    :ok
  end

  @spec register_user(Types.user, Types.login_token, binary, Types.root_object) :: :ok | {:error, String.t}
  def register_user(user, _login_token, register_token, _root_object) :: :ok | {:error, String.t} do
    with :ok <- user_name_valid(user),
         :ok <- register_token_valid(register_token)
      do
      :ok
    else
      err -> err
    end
  end

  @spec register_token_valid(binary) :: :ok | {:error, String.t}
  defp register_token_valid(register_token) do
    :ok
  end

  @spec user_name_valid(Types.user) :: :ok | {:error, String.t}
  defp user_name_valid(user) do
    :ok
  end

end
