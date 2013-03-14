<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>

<script type="text/javascript">

    $(document).ready(function()
    {
        $('img.grails').attr('src', '<g:resource  dir="images" file="grails-logo.png"/>');
        $('img.spring').attr('src', '<g:resource  dir="images" file="spring.png"/>');
        $('img.bootstrap').attr('src', '<g:resource  dir="images" file="bootstrap.png"/>');
        $('img.jquery').attr('src', '<g:resource  dir="images" file="icon-jquery.png"/>');
        $('img.openshift').attr('src', '<g:resource  dir="images" file="openshift.png"/>');
        $('img.less').attr('src', '<g:resource  dir="images" file="less-icon.png"/>');
        $('img.googl').attr('src', '<g:resource dir="images" file="url_shortener_logo.gif"/>');
    });

</script>

<div class="row">
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4><g:message code="about.generalities.title"/></h4></span>
            <g:message code="about.generalities.paragraph"/>
        </div>
    </div>
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4><g:message code="about.usage.title"/></h4></span>
            <g:message code="about.usage.paragraph"/>
        </div>

        <div class="section">
            <span class="section-title"><h4><g:message code="about.twitter.title"/></h4></span>
            <g:message code="about.twitter.paragraph"/>
        </div>
    </div>
    <div class="span4">
        <div class="section">
            <span class="section-title"><h4><g:message code="about.technology.title"/></h4></span>
            <g:message code="about.technology.paragraph"/>
        </div>

        <div class="section">
            <span class="section-title"><h4><g:message code="about.contact.title"/></h4></span>
            <g:message code="about.contact.paragraph" args="${[ConfigurationHolder.getConfig().contact.mail]}"/>
        </div>

    </div>
</div>
