<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main" />
    <title>Login</title>
    <!--openid:css /-->
</head>
<body>
<h1>Login</h1>

<!-- doc at http://grails.org/plugin/openid -->
<openid:hasLoginError>
    <div class="errors">
        <ul>
            <li><openid:renderLoginError /></li>
        </ul>
    </div>
</openid:hasLoginError>
<openid:form success="[controller:'link', action:'list']" error="[controller:'login', action:'error']">
    <openid:input size="30" value="http://"
                  extendedAttrs="[fullname:[typeUri:'http://openid.net/schema/namePerson/friendly',required:true],email:[typeUri:'http://openid.net/schema/contact/email',required:true]]"
                  sregAttrs="[fullname :true, email:true,language:true]"/> (e.g. http://username.myopenid.com)
    <br/>
    <g:submitButton name="login" value="Login" />
</openid:form>
</body>
</html>