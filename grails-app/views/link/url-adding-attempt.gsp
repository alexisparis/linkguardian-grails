<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title><g:message code="links.title"/></title>
        <r:require modules="mustache"/>

	</head>
	<body>

        <div id="messageContainer" class="message-box" style="height: 38px; margin-top: 20px; margin-bottom: 10px;">
            <div id="message"></div>
        </div>

        <div class="span12" style="text-align: center;">
            <a href="<g:createLink controller="link" action="list" absolute="true"/>" class="btn btn-primary" style="color: white;">
                <g:message code="addUrl.returnToYourLinks.button.label"/>
            </a>
        </div>

        <g:javascript>
            var infiniteScrollLoadImage = '${resource(dir: "images/loading", file: "loading_medium.gif")}';
            var noTagsFoundError  = '<g:message code="links.cloudtags.noTagsFoundError.label"/>';
            var defaultErrorMessage = '<g:message code="default.errorMessage.label"/>';
            var markAsReadMessage = '<g:message code="links.dialogs.markAsReadDialog.label"/>';
            var markAsReadFromMessage = '<g:message code="links.dialogs.markAsReadDialog.from.label"/>';
            var infinitescrollFinishedMsg = '<g:message code="infinitescroll.links.finishedMsg"/>';
            var infinitescrollMsgText = '<g:message code="infinitescroll.links.msgText"/>';
            var templateI18n = {
                goto : '<g:message code="links.link.template.domain.goto"/>',
                addTag : '<g:message code="links.link.template.domain.addTag"/>',
                deleteLink : '<g:message code="links.link.template.domain.deleteLink"/>',
                markAsRead : '<g:message code="links.link.template.domain.markAsRead"/>',
                markAsUnread : '<g:message code="links.link.template.domain.markAsUnread"/>',
                deleteTag : '<g:message code="links.link.template.domain.deleteTag"/>',
                filterOnTag : '<g:message code="links.link.template.domain.filterOnTag"/>'
            };
            //var  = '<g:message code=""/>';
        </g:javascript>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script>
        <g:javascript>
            permanentMessage = true;
        </g:javascript>

        <g:javascript>
            $(document).ready(
                    function()
                    {
                        var r = ${res as grails.converters.JSON};
                        if ( r )
                        {
                            displayMessage(r);
                        }
                    });
        </g:javascript>

	</body>
</html>
