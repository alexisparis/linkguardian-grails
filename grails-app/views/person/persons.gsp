<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title><g:message code="links.title"/></title>
        <r:require modules="mustache"/>

        <link rel="stylesheet" href="${resource(dir: 'css', file: 'persons.css')}" type="text/css">

        <style type="text/css">
            /*#infscr-loading
            {
                margin-right: auto;
                margin-left: auto;
                text-align: center;
            }
            #infscr-loading > img
            {
                margin-right: auto;
                margin-left: auto;
            }*/
        </style>

	</head>
	<body>

        <div style="margin-top: 5px;">
        </div>

        <div id="no-result" class="alert alert-info message-box" style="display: none;">
            <g:message code="persons.noresult.label"/>
        </div>

        <%--
            problem with masonry when no elements are in the listing-part when masonry initialization
            so --> factice item added to fix it
        --%>
        <div id="listing-part">
            <div class="personpart" style="display: none;"></div>
        </div>

        <div id="nav-inf-scroll" style="display: none;">
            <a href="<g:createLink controller="person" action="persons"/>?username=username/>&format=json&page=2">infinite-scroll person</a>
        </div>

        <div id="inf-scroll-load" style="margin-left: auto; margin-right: auto;">

        </div>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.infinitescroll.min.js')}"></script>

        <g:javascript>
                var infiniteScrollLoadImage = '${resource(dir: "images/loading", file: "loading_medium.gif")}';
                var infinitescrollFinishedMsg = '<g:message code="infinitescroll.persons.finishedMsg"/>';
                var infinitescrollMsgText = '<g:message code="infinitescroll.persons.msgText"/>';
                var rootUrl = '<g:createLink absolute="true" uri="/"/>';
                var personsLinksGoToTooltip = '<g:message code="persons.links.goto.tooltip"/>';
                var linkLabel = '<g:message code="link.label"/>';
        </g:javascript>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'persons.js')}"></script>

        <g:javascript>
            $(document).ready(
                    function()
                    {
                        var $container = $('#listing-part');
                        $container.imagesLoaded(function(){

                            $container.masonry({
                                                   itemSelector : '#listing-part .personpart',
                                                   isAnimated: false,
                                                   animationOptions: {
                                                      duration: 750,
                                                      easing: 'swing',
                                                      queue: false
                                                   }
                                               });
                        });

                        //TOTO
                        <g:if test="${persons}">
                            var persons = ${persons as grails.converters.JSON};
                        </g:if>
                        <g:else>
                            var persons = [];
                        </g:else>
                        updatePersons(persons);

                        $('#searchUsernameInput').val('${username}');

                        $('#listing-part').on('click', 'div.personpart', function(event)
                        {
                            window.location.href = $(this).attr('data-link-url');
                        });
                    });
        </g:javascript>

	</body>
</html>
