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
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
        <!--link rel="stylesheet" href="${resource(dir: 'css', file: 'application.css')}" type="text/css"-->
		<g:layoutHead/>
		<r:layoutResources />
        <ga:trackPageview />
	</head>
	<body class="container">
        <div class="row">
            <div class="span10">
                <div id="guardianLogo" role="banner">
                    <a href="https://linkguardian-blackdog.rhcloud.com">
                        <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/>
                    </a>
                    <h2 style="display: inline;">Link Guardian</h2>
                </div>
                <g:layoutBody/>
                <div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
                <g:javascript library="application"/>
            </div>
        </div>
        <r:layoutResources />
	</body>
</html>
