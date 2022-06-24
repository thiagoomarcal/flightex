defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()
    File.write(filename, booking_list)
  end

  def generate_report(from_date, to_date, filename) do
    # BookingAgent.start_link(%{})

    BookingAgent.list_between(from_date, to_date)
    |> build_booking_list()
    |> handle_build_booking_list(filename)
  end

  defp handle_build_booking_list({:ok, booking_list}, filename) do
    File.write(filename, booking_list)
    {:ok, "Report generated successfully"}
  end

  defp handle_build_booking_list({:error, message}, _filename) do
    {:error, message}
  end

  defp build_booking_list([_first | _rest] = bookings) do
    booking_list =
      bookings
      |> Enum.map(&booking_string/1)

    {:ok, booking_list}
  end

  defp build_booking_list([]) do
    {:error, "There are no bookings between these dates"}
  end

  defp build_booking_list do
    BookingAgent.start_link(%{})

    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(&booking_string/1)
  end

  defp booking_string(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
