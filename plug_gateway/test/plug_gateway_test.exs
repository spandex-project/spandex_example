defmodule PlugGatewayTest do
  use ExUnit.Case
  doctest PlugGateway

  test "greets the world" do
    assert PlugGateway.hello() == :world
  end
end
