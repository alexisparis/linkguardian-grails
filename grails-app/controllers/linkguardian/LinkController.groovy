package linkguardian

import grails.util.GrailsUtil

class LinkController
{
    static defaultAction = "list"

    def list(Boolean archived, String token)
    {
      println("calling list from LinkController with archived=" +archived + " and filter equals to " + token)

      def filteredLinks = []
      def link1 = new Link()
      link1.url = "http://www.google.com"
      link1.archived = false
      link1.note = Note.Note_3
      filteredLinks.add(link1)

      def link2 = new Link()
      link2.url = "http://www.blackdog-project.org"
      link2.archived = false
      link2.note = Note.Note_4
      filteredLinks.add(link2)

      [links : filteredLinks]
    }

    def addUrl(String url)
    {
      println("calling addUrl with url : " +url)
    }
}
