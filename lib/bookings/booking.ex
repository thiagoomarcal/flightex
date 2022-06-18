defmodule Flightex.Bookings.Booking do
  @keys [:complete_date, :local_origin, :local_destination, :user_id]
  @enforce_keys @keys
  defstruct @keys ++ [:id]

  def build(%NaiveDateTime{} = complete_date, local_origin, local_destination, user_id) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       complete_date: complete_date,
       local_origin: local_origin,
       local_destination: local_destination,
       user_id: user_id
     }}
  end

  def build(_complete_date, _local_origin, _local_destination, _user_id) do
    {:error, "Invalid parameters"}
  end
end
