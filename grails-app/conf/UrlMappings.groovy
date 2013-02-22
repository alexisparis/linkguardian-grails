class UrlMappings {

	static mappings = {

      "/"(controller: "link", action: "list")
      "/admin/users"(controller: "userCrud")
      "/admin/roles"(controller: "roleCrud")
      "/admin/links"(controller: "linkCrud")

      "/filter"(controller: "link", action: "filter")

      "/$controller/$action?/$id?" {
        constraints {

        }
      }

      "500"(view: '/error')
    }
}
