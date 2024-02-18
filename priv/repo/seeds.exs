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
  done: false
})

Repo.insert!(%Todo{
  name: "Second Todo",
  done: false
})

Repo.insert!(%Todo{
  name: "Third Todo",
  done: true
})
