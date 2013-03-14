package linkguardian.link

/**
 * Created with IntelliJ IDEA.
 * User: alexis
 * Date: 14/03/13
 * Time: 11:33
 * To change this template use File | Settings | File Templates.
 */
class LinkTarget
{
    String stringUrl
    URL url
    String contentType
    int responseCode = 0
    URLConnection connection
    TargetDeterminationError error
    Exception exception

    def isHtml()
    {
        contentType != null && contentType.startsWith("text/html")
    }

    def getHeaderLocation()
    {
        connection?.getHeaderField("location")
    }

    def isRedirection()
    {
        responseCode >= 300 && responseCode < 400
    }

    def isClientError()
    {
        responseCode >= 400 && responseCode < 500
    }

    def isServerError()
    {
        responseCode >= 500 && responseCode < 600
    }
}
