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
        body
        {
            display: none;
        }

    </style>
</head>

<body>

    <g:javascript>
        var container = $('body');

        container.imagesLoaded(function()
                               {
                                   container.fadeIn(1000);
                               });
    </g:javascript>

    <div id="container">

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
    </div>

    <%-- put here to have the imagesLoaded method --%>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>

</body>
</html>
