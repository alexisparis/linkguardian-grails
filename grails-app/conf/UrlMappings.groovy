class UrlMappings {

	static mappings = {

      "/"(controller: "link", action: "list")
      "/admin/users"(controller: "userCrud")
      "/admin/roles"(controller: "roleCrud")
      "/admin/links"(controller: "linkCrud")

      "/recent"(controller:  'link', action: "recentsLinks")

      "/filter"(controller: "link", action: "filter")

      "/$controller/$action?/$id?" {
        constraints {

        }
      }
      "/profile/$linksofuser/$tag?"(controller:"link", action:"list", cons)

      "500"(view: '/error')
    }
}
