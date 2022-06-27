# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report/3" do
    setup do
      Flightex.start_agents()

      bookings = [
        %{
          complete_date: ~N[2021-03-22 19:29:25.607218],
          id: "b0f593f9-8972-4598-be10-80573609bb8d",
          local_destination: "Salvador",
          local_origin: "Vitória",
          user_id: "user_id1"
        },
        %{
          complete_date: ~N[2021-03-14 12:12:25.607218],
          id: "e361655d-7c40-4b97-bd7e-2e2dec68ee3f",
          local_destination: "Rio de Janeiro",
          local_origin: "São Paulo",
          user_id: "user_id2"
        },
        %{
          complete_date: ~N[2021-04-18 08:45:25.607218],
          id: "d1c806aa-66c0-4493-8765-eec3ee593e62",
          local_destination: "Londres",
          local_origin: "São Paulo",
          user_id: "user_id1"
        }
      ]

      Enum.each(bookings, fn booking -> Flightex.create_or_update_booking(booking) end)

      :ok
    end

    test "when called, it returns a new file containing a list of bookings registered in the date range entered." do
      from_date = ~D[2021-03-14]
      to_date = ~D[2021-04-18]

      content =
        "user_id1,Vitória,Salvador,2021-03-22 19:29:25.607218\n" <>
          "user_id2,São Paulo,Rio de Janeiro,2021-03-14 12:12:25.607218\n" <>
          "user_id1,São Paulo,Londres,2021-04-18 08:45:25.607218\n"

      Flightex.generate_report(from_date, to_date)
      {:ok, file} = File.read("report_between_dates.csv")

      assert file =~ content
    end

    test "when the date range has no bookings registered, returns an error" do
      from_date = ~D[2021-04-19]
      to_date = ~D[2021-04-24]

      expected_response = {:error, "There are no bookings between these dates"}

      response = Flightex.generate_report(from_date, to_date)
      assert response == expected_response
    end
  end
end
