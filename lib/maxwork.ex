defmodule Maxwork do

  def get_listing(id) do
    case HTTPoison.get("https://s.maxwork.pt/site/static/9/listings/details/" <> id <> ".html") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          %{ agent_name: get_agent_name(body),
             agent_picture: get_agent_picture(body),
             price: get_price(body),
             bedroom: get_bedroom(body),
             bathroom: get_bathroom(body),
             area: get_area(body),
             listing_picture: get_listing_picture(body)
          }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp get_agent_name(body) do
    body
    |> Floki.find(".agent-name")
    |> hd
    |> elem(2)
    |> hd
    |> elem(2)
    |> hd
  end

  defp get_price(body) do
    body
    |> Floki.find(".listing-price")
    |> hd
    |> elem(2)
    |> hd
  end

  defp get_bedroom(body) do
    body
    |> Floki.find(".listing-bedroom")
    |> hd
    |> elem(2)
    |> List.last()
  end

  defp get_bathroom(body) do
    body
    |> Floki.find(".listing-bathroom")
    |> hd
    |> elem(2)
    |> List.last()
  end

  defp get_area(body) do
    body
    |> Floki.find(".listing-area")
    |> hd
    |> elem(2)
    |> tl
    |> hd
  end

  defp get_agent_picture(body) do
    body
    |> Floki.find(".agent-picture")
    |> hd
    |> elem(2)
    |> hd
    |> elem(1)
    |> tl
    |> hd
    |> elem(1)
  end

  defp get_listing_picture(body) do
    body
    |> Floki.find(".listing-picture-big")
    |> hd
    |> elem(2)
    |> hd
    |> elem(2)
    |> hd
    |> Floki.attribute("srcset")
    |> hd
  end

end
