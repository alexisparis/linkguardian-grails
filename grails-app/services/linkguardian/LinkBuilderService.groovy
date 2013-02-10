package linkguardian

import net.htmlparser.jericho.*

class LinkBuilderService {

    def shortenerService

    def complete(Link link) {

      // make an http request to get the header of the web site

      MicrosoftTagTypes.register()
      //MicrosoftConditionalCommentTagTypes.register();
      PHPTagTypes.register()
      PHPTagTypes.PHP_SHORT.deregister() // remove PHP short tags for this example otherwise they override processing instructions
      MasonTagTypes.register()
      java.net.URL url = new java.net.URL(link.url)

      Source source=new Source(url)

      // Call fullSequentialParse manually as most of the source will be parsed.
      source.fullSequentialParse()

      link.title = getTitle(source)
      println "title : " + link.title

      link.description = getMetaValue(source,"description")
      println "description : " + link.description

      if ( link.description == null )
      {
        link.description = ""
      }

      link.domain = url.getHost()
      println "domain : " + link.domain

      // shorten url with google service
      def urlResource = shortenerService.shorten(link.url)
      link.url = urlResource.shortUrl
    }


    def getTitle(Source source) {
      Element titleElement=source.getFirstElement(HTMLElementName.TITLE);
      if (titleElement==null) return null;
      // TITLE element never contains other tags so just decode it collapsing whitespace:
      return CharacterReference.decodeCollapseWhiteSpace(titleElement.getContent());
    }

    def getMetaValue(Source source, String key) {
      for (int pos=0; pos<source.length();) {
        StartTag startTag=source.getNextStartTag(pos,"name",key,false);
        if (startTag==null) return null;
        if (startTag.getName()==HTMLElementName.META)
          return startTag.getAttributeValue("content"); // Attribute values are automatically decoded
        pos=startTag.getEnd();
      }
      return null;
    }
}
