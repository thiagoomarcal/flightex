defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent
  alias Flightex.Bookings.Booking

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      })
      when is_struct(complete_date) do
    booking =
      struct(Booking, %{
        id: UUID.uuid4(),
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      })

    Agent.save(booking)
    {:ok, booking.id}
  end

  def call(_params), do: {:error, "Invalid params"}
end
