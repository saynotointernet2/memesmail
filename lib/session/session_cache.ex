defmodule Memesmail.Session.SessionCache do
  @moduledoc """
  Interface to user session structure
  """

  alias Memesmail.Model.Types, as: Types
  alias __MODULE__, as: SessionCache

  defstruct nonces: %{}, tokens: %{}, nonce_timeout: 60000, login_timeout: 120000

  @type t :: %SessionCache{}
  @typep user_nonce :: {Types.nonce, integer}
  @typep user_token :: {Types.session_token, integer}

  @spec new(integer, integer) :: t
  def new(nonce_timeout, login_timeout) do
    %SessionCache{nonces: %{}, tokens: %{}, nonce_timeout: nonce_timeout, login_timeout: login_timeout}
  end

  @spec update_nonce(t, Types.user, Types.nonce, integer) :: t
  def update_nonce(cache, user, nonce, timestamp) do
    Map.put(
      cache,
      :nonces,
      Map.put(
        cache.nonces,
        user,
        {nonce, timestamp}
      )
    )
  end

  @spec set_token(t, Types.user, Types.user_token, integer) :: t
  def set_token(cache, user, token, timestamp) do
    remove_nonce(cache, user)
    |> Map.put(
         :tokens,
         Map.put(
           cache.tokens,
           user,
           {token, timestamp}
         )
       )
  end

  @spec clear_user(t, Types.user) :: t
  def clear_user(cache, user) do
    %SessionCache{cache | nonces: Map.delete(cache.nonces, user), tokens: Map.delete(cache.tokens, user)}
  end

  @spec try_nonce(t, Types.user, integer) :: {:ok, Types.nonce} | {:timeout, t} | nil
  def try_nonce(cache, user, current) do
    timeout = cache.nonce_timeout
    case get_nonce(cache, user) do
      nil -> nil
      {_, ts} when current - ts > timeout -> {:timeout, remove_nonce(cache, user)}
      {nonce, _} -> {:ok, nonce}
    end
  end

  @spec try_token(t, Types.user, Types.session_token, integer) :: {:ok | :timeout | :invalid, t}
  def try_token(cache, user, token, current) do
    timeout = cache.login_timeout
    case get_token(cache, user) do
      nil -> nil
      {_, ts} when current - ts > timeout -> {:timeout, clear_user(cache, user)}
      {^token, _} -> {:ok, cache}
      _ -> {:invalid, clear_user(cache, user)}
    end
  end

  @spec get_nonce(t, Types.user) :: user_nonce | nil
  defp get_nonce(cache, user) do
    cache.nonces[user]
  end

  @spec get_token(t, Types.user) :: user_token | nil
  defp get_token(cache, user) do
    cache.tokens[user]
  end

  @spec remove_nonce(t, Types.user) :: t
  defp remove_nonce(cache, user) do
    %SessionCache{cache | nonces: Map.delete(cache.nonces, user)}
  end

end