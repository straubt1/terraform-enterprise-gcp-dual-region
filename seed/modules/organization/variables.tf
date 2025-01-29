variable "organization" {
  type = object({
    email                = string
    number_of_projects   = number
    number_of_workspaces = number
  })
}
