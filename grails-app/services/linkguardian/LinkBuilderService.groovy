package linkguardian

import linkguardian.exception.TagException
import linkguardian.exception.UnsupportedTypeException
import linkguardian.link.LinkTarget
import linkguardian.link.TargetDeterminationError
import net.htmlparser.jericho.*

class LinkBuilderService {

    def shortenerService

    def stringNormalizerService

    def clone(Link link)
    {
        def result = null;

        if ( link )
        {
            result = new Link()
            result.title = link.title
            result.description = link.description
            result.domain = link.domain
            result.url = link.url
            result.read = link.read
            result.note = link.note
            result.creationDate = link.creationDate
            result.locked = link.locked

            link.tags.each {
                result.addToTags(it)
            }
        }

        return result
    }

    def complete(Link link, LinkTarget target) {

        log.info "completing link with url : " + link.url + " and target : " + target

        //java.net.URL url = new java.net.URL(link.url)
        if ( target.isHtml() && ! target.isClientError() && ! target.isServerError() )
        {
            this.completeHtml(link, target)
        }
        else
        {
            this.completeDefault(link, target)
        }

        if ( link.title == null )
        {
            link.title = ""
        }
        if ( link.description == null )
        {
            link.description = ""
        }

        link.domain = target.url.getHost()
        log.info "setting domain to " + link.domain

        // shorten url with google service
        def urlResource = shortenerService.shorten(link.url)

        log.info "url shortening for : " + link.url + " returns " + urlResource.shortUrl

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
            log.info "tag found for " + it + " ? " + _tag
            if ( _tag == null )
            {
                log.info "creating new tag"
                if ( it.length() > Tag.LABEL_MAX_LENGTH )
                {
                    throw new TagException("the tag '" + it.substring(10) + "...' is too long (" + Tag.LABEL_MAX_LENGTH + " characters maximum)")
                }

                _tag = new Tag(label:  it)
                //_tag.save()
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

    /* ##############################
       TARGET DETERMINATION
       ############################## */

    def determineTarget(String url)
    {
        def target = new LinkTarget()

        // manage redirect url
        def urls = new HashSet<String>()
        def redirectLimitCount = 10
        def redirectCount = 0
        def currentUrl = url

        boolean stopLoop = false

        try
        {
            while(!stopLoop)
            {
                if ( urls.add(currentUrl) )
                {
                    target.stringUrl = currentUrl
                    target.url = new URL(currentUrl)
                    target.connection = target.url.openConnection()
                    target.contentType = null
                    target.responseCode = 0

                    if ( target.connection instanceof HttpURLConnection )
                    {
                        def _httpConnection = (HttpURLConnection)target.connection
                        _httpConnection.setInstanceFollowRedirects(true)

                        target.responseCode = _httpConnection.getResponseCode()
                        log.debug "getting http code " + target.responseCode +" for url " + target.stringUrl
                        log.debug "connection url : " + target.connection.getURL()

                        target.contentType = _httpConnection.getHeaderField("content-type")
                        log.debug "content type : " + target.contentType

                        if ( log.isDebugEnabled() )
                        {   _httpConnection.headerFields.each {
                                log.debug "   " + it.key + " ==> " + it.value
                            }
                        }

                        if( target.isRedirection() )
                        {
                            log.debug "it's a redirection"
                            currentUrl = null

                            def location = target.getHeaderLocation()
                            if ( location != null ){
                                currentUrl = location
                                log.debug "setting current url to " + location
                            }
                        }
                        else if ( target.isClientError() || target.isServerError() )
                        {
                            // the host seems to exist because no UnknwonHostException thrown
                            // but for some reason, access to this url from openshift server provoke errors
                            // we won't be able to parse the real page but we will try to extract a title from the url
                            stopLoop = true
                        }
                        else
                        {
                            target.stringUrl =  _httpConnection.getURL().toString() // could be different from currentUrl !!!!
                            stopLoop = true
                        }
                    }
                    else
                    {
                        log.error("don't know what to do with a connection of type : " + _connection.getClass())
                        target.error = TargetDeterminationError.INVALID_CONNECTION_TYPE
                        stopLoop = true
                    }
                }
                else
                {
                    log.debug "url " + currentUrl + " already visited ==> redirection loop"
                    target.error = TargetDeterminationError.INFINITE_LOOP
                    stopLoop = true
                }

                redirectCount++

                if ( ! stopLoop && redirectCount >= redirectLimitCount )
                {
                    target.error = TargetDeterminationError.TOO_MANY_LOOP
                    stopLoop = true
                }
            }
        }
        catch(UnknownHostException e)
        {
            target.error = TargetDeterminationError.UNKNOWN_HOST_EXCEPTION
            target.exception = e
            log.error("unknown host exception", e)
        }
        catch(MalformedURLException e)
        {
            target.error = TargetDeterminationError.MALFORMED_URL
            target.exception = e
            log.error("malformed url : " + url, e)
        }
        catch(Exception e)
        {
            target.error = TargetDeterminationError.EXCEPTION
            target.exception = e
            log.error(e.getClass().name + " with cause : " + e.getCause()?.getClass()?.name + " :: error while trying to resolve redirections", e)
        }

        target
    }

    /* ##############################
       COMMON
       ############################## */

    private def extractFilenameFrom(URL url)
    {
        def result = null

        if ( url )
        {
            result = url.getFile()
            def lastSlashIndex = result.lastIndexOf('/')

            if ( lastSlashIndex > -1 )
            {
                result = result.substring(lastSlashIndex + 1)

                ['-', '_'].each {
                    result = result.replace(it, ' ')
                }
            }
        }

        return result
    }

    /* ##############################
       DEFAULT
       ############################## */

    private def completeDefault(Link link, LinkTarget target)
    {
        link.title = this.extractFilenameFrom(target.url)
    }

    /* ##############################
       HTML
       ############################## */

    private def completeHtml(Link link, LinkTarget target)
    {
        // make an http request to get the header of the web site

        MicrosoftTagTypes.register()
        //MicrosoftConditionalCommentTagTypes.register();
        PHPTagTypes.register()
        PHPTagTypes.PHP_SHORT.deregister() // remove PHP short tags for this example otherwise they override processing instructions
        MasonTagTypes.register()

        Source source=new Source(target.connection)

        // Call fullSequentialParse manually as most of the source will be parsed.
        source.fullSequentialParse()

        link.title = getTitle(source)
        log.info "setting title to " + link.title

        link.description = getMetaValue(source,"description")
        log.info "setting description to " + link.description
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
