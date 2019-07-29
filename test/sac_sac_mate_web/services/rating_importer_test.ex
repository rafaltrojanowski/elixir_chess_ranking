defmodule SacSacMate.Services.RatingImporterTest do

  use SacSacMateWeb.ConnCase
  alias SacSacMate.Services.RatingImporter

  test "downloads data" do
    file_name = "standard_feb14frl_xml_short.xml"
    path = "fixture/files/#{file_name}"

    RatingImporter.call(path)
  end
end
