
<div class="row">
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4><g:message code="about.generalities.title"/></h4></span>
            <g:message code="about.generalities.paragraph"/>
        </div>

        <div class="section">
            <span class="section-title"><h4><g:message code="about.privacy.title"/></h4></span>
            <g:message code="about.privacy.paragraph"/>
        </div>
    </div>
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4><g:message code="about.usage.title"/></h4></span>
            <g:message code="about.usage.paragraph"/>
        </div>

        <div class="section">
            <span class="section-title"><h4><g:message code="about.twitter.title"/></h4></span>
            <g:message code="about.twitter.paragraph" argsa="${ ['${resource(dir: \'images\', file: \'twitter.png\')}'] }" />
        </div>
    </div>
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4>Technology</h4></span>
            <p><span class="lg"></span> uses several modern web technologies like :
                <ul>
                    <li><a target="_blank" href="http://grails.org/"><img src="${resource(dir: 'images', file: 'grails-logo.png')}" width="20px"/> Grails</a></li>
                    <li><a target="_blank" href="http://www.springsource.org"><img src="${resource(dir: 'images', file: 'spring.png')}" width="20px"/> Spring</a></li>
                    <li><a target="_blank" href="http://twitter.github.com/bootstrap/"><img src="${resource(dir: 'images', file: 'bootstrap.png')}" width="20px"/> Twitter Bootstrap</a></li>
                    <li><a target="_blank" href="http://jquery.com/"><img src="${resource(dir: 'images', file: 'icon-jquery.png')}" width="70px"/></a></li>
                    <%--li><a target="_blank" href="http://lesscss.org/"><img src="${resource(dir: 'images', file: 'less-icon.png')}" width="40px"/></a></li--%>
                </ul>
            </p>
            <p>
                It is freely deployed on <a target="_blank" href="http://openshift.redhat.com"><img src="${resource(dir: 'images', file: 'openshift.png')}" width="20px"/> Red Hat Openshift</a>.
            </p>
        </div>

        <div class="section">
            <span class="section-title"><h4>Contact</h4></span>
            <p>For new features, bugs, problems or information, please contact the <a target="_blank" href="mailto:alexis.rt.paris@gmail.com">administrator</a>.

        </div>

    </div>
</div>
