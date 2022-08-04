# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SacSacMate.Repo.insert!(%SacSacMate.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%SacSacMate.Accounts.Player{fideid: 1234, last_name: "Last name", country: "Poland"} |> SacSacMate.Repo.insert!
%SacSacMate.Accounts.Player{fideid: 4321, last_name: "Last name #2", country: "Germany"} |> SacSacMate.Repo.insert!
