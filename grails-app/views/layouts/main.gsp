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

        <link href='http://fonts.googleapis.com/css?family=Clicker+Script' rel='stylesheet' type='text/css'>

		<g:layoutHead/>
		<r:layoutResources />
        <ga:trackPageview />

        <style type="text/css">
            div.navbar-inner
            {
                color: white;

                background: #0c4d99; /* Old browsers */
                background: -moz-linear-gradient(top, #0c4d99 0%, #0075d6 49%, #006ec9 50%, #0d88e5 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#0c4d99), color-stop(49%,#0075d6), color-stop(50%,#006ec9), color-stop(100%,#0d88e5)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #0c4d99 0%,#0075d6 49%,#006ec9 50%,#0d88e5 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #0c4d99 0%,#0075d6 49%,#006ec9 50%,#0d88e5 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #0c4d99 0%,#0075d6 49%,#006ec9 50%,#0d88e5 100%); /* IE10+ */
                background: linear-gradient(to bottom, #0c4d99 0%,#0075d6 49%,#006ec9 50%,#0d88e5 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#0c4d99', endColorstr='#0d88e5',GradientType=0 ); /* IE6-9 */
            }

        </style>
    </head>

	<body>
        <div class="navbar" style="margin-bottom: 0px;">
            <div class="navbar-inner">
                <div class="container wrapper">
                    <div class="row">
                        <div class="span10">
                            <div id="guardianLogo" role="banner" style="padding-top: 5px; padding-bottom: 3px;">
                                <a href="https://linkguardian-blackdog.rhcloud.com">
                                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50" style="margin-top: -10px;"/>
                                </a>
                                <span style="display: inline-block; padding-top: 14px; font-family: 'Clicker Script', cursive; font-size: 30px;">Link Guardian</span>
                                <sec:ifLoggedIn>
                                    <div style="float: right; text-align: right;">
                                        <span>Welcome <sec:loggedInUserInfo field="username"/></span><br/>
                                        <g:link controller='logout' action='index'><span class="btn btn-inverse btn-mini">Logout</span></g:link>
                                    </div>
                                </sec:ifLoggedIn>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container wrapper">
            <div class="row">
                <div class="span10">
                    <g:layoutBody/>
                    <g:javascript library="application"/>
                </div>
            </div>
        </div>
        <r:layoutResources />
	</body>
</html>
