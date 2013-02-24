package linkguardian



import grails.test.mixin.*
import org.junit.*

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(StringNormalizerService)
class StringNormalizerServiceTests
{
    def stringNormalizerService = new StringNormalizerService()

    void testNormalize()
    {
        def data = [:]
        data.put("[]", null)
        data.put("[]", "")
        data.put("[]", "  ")
        data.put("[a]", "a")
        data.put("[a, b]", "a b")
        data.put("[a, b, b]", "a b b")
        data.put("[a, b]", " a b")
        data.put("[a, b]", "a b ")
        data.put("[a, b]", " a b ")
        data.put("[a, b]", " a  b ")
        data.put("[a, b]", "  a  b  ")
        data.put("[e]", "é")
        data.put("[e]", " é   ")
        data.put("[eaecu]", "éàèçù")
        data.put("[]", "-¨<>'!%*£+/.?")
        data.put("[]", "_%+=&@")

        data.each {
            assertEquals(it.key, stringNormalizerService.normalize(it.value).toString())
        }
    }
}
