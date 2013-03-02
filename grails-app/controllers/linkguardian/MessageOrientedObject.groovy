package linkguardian

/**
 * Created with IntelliJ IDEA.
 * User: alexis
 * Date: 02/03/13
 * Time: 00:03
 * To change this template use File | Settings | File Templates.
 */
class MessageOrientedObject
{
    def success(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.SUCCESS)
    }

    def error(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.ERROR)
    }

    def warning(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.WARNING)
    }
}
