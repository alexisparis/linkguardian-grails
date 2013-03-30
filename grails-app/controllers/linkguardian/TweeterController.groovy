package linkguardian

class TweeterController
{
    def shortenerService

    def linkBuilderService

    def tweetLink(String url)
    {
        def target = linkBuilderService.determineTarget(url)

        if ( target.error == null )
        {
            log.debug "creating detached link... with url : " + target.stringUrl
            def newLink = new Link(url: target.stringUrl, fusionedTags: "  ", creationDate: new Date())
            log.debug "detached link created"

            linkBuilderService.complete(newLink, target)
            log.debug "link completed"

            def message = newLink.title + " " + newLink.url + " (via @linkguardian)";

            redirect(url: "https://twitter.com/home?status=" + encodeURIComponent(message))
        }
    }

    def String encodeURIComponent(String component)
    {
        String result = null;

        try {
            result = URLEncoder.encode(component, "UTF-8").
                    replaceAll("\\%28", "(").
                    replaceAll("\\%29", ")").
                    replaceAll("\\+", "%20").
                    replaceAll("\\%27", "'").
                    replaceAll("\\%21", "!").
                    replaceAll("\\%7E", "~")
        }
        catch (UnsupportedEncodingException e) {
            result = component;
        }

        return result;
    }
}
