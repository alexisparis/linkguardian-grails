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

        <div class="container forms">
        </div>

        <div id="no-result" class="alert alert-info message-box" style="display: none;">
            <g:message code="persons.noresult.label"/>
        </div>

        <%--
            problem with masonry when no elements are in the listing-part when masonry initialization
            so --> factice item added to fix it
        --%>
        <div id="listing-part">

            <div class="personpart with-tooltip" style="" rel="tooltip" data-placement="left" data-original-title="voir ses liens"
                    data-link-url="<g:createLink absolute="true" uri="/"/>profile/OlivierCroisier">
                <img class="twitter-account" data-twitter-name="OlivierCroisier" data-twitter-icon-size="bigger"
                    style="margin-top: 5px; margin-bottom: 5px; margin-left: 5px;"/>
                <span style="margin-left: 5px;">OlivierCroisier</span>
                <span style="float: right">2 links</span>
            </div>

            <div class="personpart" style="display: none;"></div>
        </div>

        <div id="nav-inf-scroll" style="display: none;">
            <a href="<g:createLink controller="person" action="persons"/>?page=2&format=json&username=${username}">infinite-scroll person</a>
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

                        var persons = ${persons as grails.converters.JSON};
                        updatePersons(persons);

                        $('#searchUsernameInput').val('${username}');
                    });
        </g:javascript>

	</body>
</html>
