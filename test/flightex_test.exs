defmodule FlightexTest do
  use ExUnit.Case

  describe "create_or_update_user/1" do
    test "when all params are valid, returns a new user" do
      params = %{name: "Roberto Garffet", email: "robertogarffet@gmail.com", cpf: "12345678900"}

      Flightex.start_agents()

      assert {:ok, "User created or updated sucessfully"} = Flightex.create_or_update_user(params)
    end
  end
end
