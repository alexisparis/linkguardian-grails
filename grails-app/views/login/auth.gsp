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
            <h3 class="text-center"><g:message code="auth.twitter.message"/> <b><span class="lg medium" style="font-size: 24px;"></span></b></h3>
        </p>
        <p class="text-center">
            <twitterAuth:button/>
        </p>
    </div>

    <div id="description">
        <g:include view="fragments/linkguardian_description.gsp"/>
    </div>

    <%-- put here to have the imagesLoaded method --%>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>

    <g:javascript>
        var body = $('body');
        body.hide();

        $(document).ready(function()
        {
            body.imagesLoaded(function()
            {
                body.fadeIn();
            });
        });
    </g:javascript>

</body>
</html>
