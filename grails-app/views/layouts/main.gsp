<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'shield_blue.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'shield_blue.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'shield_blue.png')}">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'application.css')}" type="text/css">
        <link href="${resource(dir: 'css', file: 'clicker.css')}" rel='stylesheet' type='text/css'>

        <r:require modules="bootstrap"/>

		<g:layoutHead/>
		<r:layoutResources />
        <ga:trackPageview />

        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.blockUI.js')}"></script>

    </head>

	<body>
        <div class="header">
            <div class="container">
                <div class="row">
                    <div class="span12">
                        <div id="guardianLogo" role="banner" style="padding-top: 5px; padding-bottom: 8px;">
                            <a href="https://linkguardian-blackdog.rhcloud.com">
                                <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50" style="margin-top: -10px;"/>
                            </a>
                            <span class="lg" style="display: inline-block; padding-top: 16px; font-size: 30px;"></span>
                            <sec:ifLoggedIn>
                                <div style="float: right; text-align: right;">

                                    <span style="margin-right: 30px;">
                                        <sec:ifAllGranted roles="ROLE_ADMIN,ROLE_USER">
                                            <div class="btn-group" style="margin-right: 20px; ">
                                                <button class="btn btn-danger dropdown-toggle" data-toggle="dropdown">Admin <span class="caret"></span></button>
                                                <ul class="dropdown-menu">
                                                    <li><g:link controller="userCrud">Users</g:link></li>
                                                    <li><g:link controller="roleCrud">Roles</g:link></li>
                                                    <li><g:link controller="linkCrud">Links</g:link></li>
                                                </ul>
                                            </div>
                                        </sec:ifAllGranted>

                                        <button class="btn btn-info" id="about">About</button>
                                    </span>

                                    <span style="margin-right: 5px;">
                                        <i class=" icon-user"></i>
                                        <g:if env="production">
                                            <sec:loggedInUserInfo field="fullName"/>
                                        </g:if>
                                        <g:else>
                                            <sec:username/>
                                        </g:else>
                                    </span>
                                    <g:link controller='logout' action='index' class="with-tooltip" rel="tooltip" data-placement="bottom" data-original-title="disconnect">
                                        <span class="btn btn-inverse btn-mini"><i class="icon-off icon-white"></i></span>
                                    </g:link>
                                </div>
                            </sec:ifLoggedIn>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container wrapper">
            <div class="row">
                <div class="span12">
                    <g:layoutBody/>
                    <g:javascript library="application"/>
                </div>
            </div>
        </div>
        <r:layoutResources />

        <footer>
            <div class="container wrapper">
                <div class="row">
                    <div class="span12 copyright" style="text-align: left;">
                        <g:message code="app.copyright"/>
                    </div>
                </div>
            </div>
        </footer>

        <div id="aboutDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> About <span class="lg" style="font-size: 24px;"></span></h3>
            </div>
            <div class="modal-body">

                <p class="text-info">Url bookmarker and domains monitoring.</p>

                <g:include view="fragments/linkguardian_description.gsp"/>

            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>

        <script type="text/javascript">

            $(document).ready(
                    function()
                    {
                        $('#about').on('click', function(event)
                        {
                            $('#aboutDialog').modal();
                        });

                        $(document).ajaxStart(function(){
                            $.blockUI(
                                    {
                                        message : '<img src="${resource(dir: "images/loading", file: "loading_big.gif")}"/>',
                                        css: {
                                            border: 'none',
                                            backgroundColor: 'none',
                                            opacity:         0.8
                                        }
                                    }
                            );
                        })
                                .ajaxStop(function(){
                                              setTimeout(function(){
                                                  $.unblockUI();
                                              }, 200); //TODO : reduce additional times
                                          });
                    });

        </script>

	</body>
</html>
