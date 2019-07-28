defmodule SacSacMate.Services.RatingImporterTest do

  use SacSacMateWeb.ConnCase
  alias SacSacMate.Services.RatingImporter


  @tag timeout: :infinity
  test "downloads data" do
    file_name = "standard_feb14frl_xml.xml"
    path = "fixture/files/#{file_name}"

    RatingImporter.call(path)
  end
end
