package linkguardian

import linkguardian.exception.TagException
import net.htmlparser.jericho.*

class LinkBuilderService {

    def shortenerService

    def stringNormalizerService

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

        if ( link.title && link.title.length() > Link.TITLE_MAX_LENGTH )
        {
            link.title = link.title.substring(0, Link.TITLE_MAX_LENGTH)
        }
        if ( link.description && link.description.length() > Link.DESCRIPTION_MAX_LENGTH )
        {
            link.description = link.description.substring(0, Link.DESCRIPTION_MAX_LENGTH)
        }
    }

    def addTags(Link link, String fusionedTags) throws TagException
    {
        def tags = this.extractTags(fusionedTags)

        tags.each {
            def _tag
            _tag = Tag.findByLabel(it)
            if ( _tag == null )
            {
                if ( it.length() > Tag.LABEL_MAX_LENGTH )
                {
                    throw new TagException("the tag '" + it.substring(10) + "...' is too long (" + Tag.LABEL_MAX_LENGTH + " characters maximum)")
                }

                _tag = new Tag(label:  it)
                _tag.save(flush:  true)
            }
            link.addToTags(_tag)
        }
    }

    /**
     * return a set of tag from the input string
     * @param fusionedTags
     */
    def extractTags(String fusionedTags)
    {
        return new LinkedHashSet<String>(stringNormalizerService.normalize(fusionedTags?.toLowerCase()))
    }

    private def getTitle(Source source) {
      Element titleElement=source.getFirstElement(HTMLElementName.TITLE);
      if (titleElement==null) return null;
      // TITLE element never contains other tags so just decode it collapsing whitespace:
      return CharacterReference.decodeCollapseWhiteSpace(titleElement.getContent());
    }

    private def getMetaValue(Source source, String key) {
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
