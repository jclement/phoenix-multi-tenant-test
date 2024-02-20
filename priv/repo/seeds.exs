# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MultiTenant.Repo.insert!(%MultiTenant.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MultiTenant.Repo
alias MultiTenant.Todos.Todo
alias MultiTenant.Notes.Note
alias MultiTenant.Tenants.Tenant

t1 =
  Repo.insert!(%Tenant{
    name: "Localhost",
    hosts: ["localhost", "127.0.0.1"]
  })

t2 =
  Repo.insert!(%Tenant{
    name: "Microeggbert Oil Corporation.",
    hosts: ["afenav.microeggbertoil.com"]
  })

if Mix.env() == :dev do
  Repo.insert!(%Note{
    title: "First Note",
    body: "This is the first note"
  })

  Repo.insert!(%Note{
    title: "Second Note",
    body: "This is the second note"
  })

  Repo.insert!(%Todo{
    name: "First Todo",
    done: false,
    tenant_id: t1.id
  })

  Repo.insert!(%Todo{
    name: "Second Todo",
    done: false,
    tenant_id: t1.id
  })

  Repo.insert!(%Todo{
    name: "Third Todo",
    done: true,
    tenant_id: t1.id
  })

  Repo.insert!(%Todo{
    name: "Another Todo",
    done: true,
    tenant_id: t2.id
  })
end
