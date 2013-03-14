package linkguardian.link

/**
 * Created with IntelliJ IDEA.
 * Person: alexis
 * Date: 27/01/13
 * Time: 21:54
 * To change this template use File | Settings | File Templates.
 */
enum TargetDeterminationError
{
    INFINITE_LOOP,
    TOO_MANY_LOOP,
    INVALID_CONNECTION_TYPE,
    UNKNOWN_HOST_EXCEPTION,
    MALFORMED_URL,
    EXCEPTION;
}
