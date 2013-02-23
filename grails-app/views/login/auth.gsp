<html>
<head>
	<meta name='layout' content='main'/>
	<title><g:message code="springSecurity.login.title"/></title>

    <link rel="stylesheet" href="${resource(dir:'css',file:'twitter-auth.css')}" />


    <style type="text/css">

        #login, .section-title
        {
            text-align: center;
        }

        #login
        {
            margin-top: 50px;
            margin-bottom: 50px;
        }

        .section
        {
            margin-bottom: 40px;
        }

        .twitter-login .twitter-button
        {
            width: 158px;
            height: 28px;
        }

    </style>
</head>

<body>

    <div id="login">
        <p>
            <h3 class="text-center"><g:message code="auth.twitter.message"/> <b><span class="lg" style="font-size: 24px;"></span></b></h3>
        </p>
        <p class="text-center">
            <twitterAuth:button/>
        </p>
    </div>

    <g:include view="fragments/linkguardian_description.gsp"/>

</body>
</html>
