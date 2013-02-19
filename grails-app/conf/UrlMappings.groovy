class UrlMappings {

	static mappings = {

      "/"(controller: "link", action: "list")
      "/admin/users"(controller: "userCrud")
      "/admin/roles"(controller: "roleCrud")
      "/admin/links"(controller: "linkCrud")

      "/$controller/$action?/$id?" {
        constraints {

        }
      }

      "500"(view: '/error')
    }
}
