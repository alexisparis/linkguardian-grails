class UrlMappings {

	static mappings = {

      "/"(controller: "link", action: "list")
      "/admin/users"(controller: "user")
      "/admin/roles"(controller: "role")

      "/$controller/$action?/$id?" {
        constraints {

        }
      }

      "500"(view: '/error')
    }
}
