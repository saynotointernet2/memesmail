defmodule Memesmail.Model.Types do
  @moduledoc """
  Memesmail model data types
  """

  @type body :: {binary}
  @type key :: {binary}
  @type object_id :: {binary}
  @type key_id :: {binary}
  @type stored_ids :: {object_id, [key_id]}
  @type object_key :: {body, key}
  @type key_id_pair :: {key_id, key}
  @type object_full :: {body, [key_id_pair]}

  @type user :: binary
  @type nonce :: binary
  @type session_token :: binary
  @type login_token :: binary
  @type register_token :: binary
  @type root_object :: binary


end