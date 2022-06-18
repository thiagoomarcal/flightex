defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf]
  @enforce_keys @keys

  defstruct @keys ++ [:id]

  def build(name, email, cpf) when is_bitstring(cpf) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       name: name,
       email: email,
       cpf: cpf
     }}
  end

  def build(_name, _email, _cpf), do: {:error, "Cpf must be a String"}
end
