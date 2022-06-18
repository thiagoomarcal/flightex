defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.{Agent, User}

  def call(%{name: name, email: email, cpf: cpf}) do
    name
    |> User.build(email, cpf)
    |> save_user()
  end

  defp save_user({:ok, %User{} = user}) do
    Agent.save(user)
    {:ok, "User created or updated sucessfully"}
  end

  defp save_user({:error, _reason} = error), do: error
end
