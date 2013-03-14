package linkguardian



import grails.test.mixin.*
import org.junit.*

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(LinkBuilderService)
class LinkBuilderServiceTests
{

    def linkBuilderService = new LinkBuilderService()

    void testExtractFilenameFrom()
    {
        def url = "http://www.dzone.com/links/r/10_object_oriented_design_principles_java_program.html"

        assertEquals("10 object oriented design principles java program", linkBuilderService.extractFilenameFrom(new URL(url)))


    }
}
