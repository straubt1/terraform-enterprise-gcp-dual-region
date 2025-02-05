resource "random_pet" "main" {
  length    = 2
  separator = "-"
}

output "name" {
  value = random_pet.main.id
}
