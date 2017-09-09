defmodule Auth.ServerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, server} = Auth.Server.start_link([nonce_timeout: 200, login_timeout: 300])
    {:ok, server: server}
  end

  test "Can not login before init message is sent", %{server: server} do
    assert Auth.Client.loginUser(server, "user", <<0>>, "sometoken") == :invalid
  end

  test "Can initialize session and receive a binary nonce of 32 bytes", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert is_binary(nonce) == true
    assert byte_size(nonce) == 32
  end


  test "Can not login without correctly calculating the login token", %{server: server} do
    Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, <<11, 12, 13, 91, 200, 01>>) == :invalid
  end

  test "Can login with correct token", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
  end

  test "Can verify token after logging in", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
  end

  test "Terminates session after attempting to continue session with invalid token", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    assert Auth.Client.verifySession(server, "user", <<11, 12, 13, 91, 200, 01>>) == :invalid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :invalid
  end

  test "Can not login a second time without re-initializing the session existing session persists", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    assert Auth.Client.verifySession(server, "user", <<11, 12, 13, 91, 200, 01>>) == :invalid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :invalid
  end

  test "Can not verify old session after logging in again", %{server: server} do
    nonce1 = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce1)) == :valid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce1)) == :valid
    nonce2 = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce2)) == :valid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce1)) == :invalid
  end

  test "Nonce should timeout", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    :timer.sleep(201)
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :timeout
  end

  test "Login token should timeout", %{server: server} do
    nonce = Auth.Client.initSession(server, "user")
    assert Auth.Client.loginUser(server, "user", <<0>>, Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :valid
    :timer.sleep(301)
    assert Auth.Client.verifySession(server, "user", Auth.Server.computeToken("user", <<0>>, nonce)) == :timeout
  end

end
