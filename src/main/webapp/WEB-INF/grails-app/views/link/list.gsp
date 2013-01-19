<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Grails</title>
        <r:require modules="bootstrap"/>
	</head>
	<body>
    <p>
        <openid:identifier />
    </p>
    <p>
        list all links

    <g:form action="addUrl">

        <g:textField name="url"/>
        <g:submitButton name="Add link" class="btn btn-primary"/>

    </g:form>

    <g:form action="list">

        Archived?<g:checkBox name="archived" title="archived" /><br/>
        Filter<g:textField name="token" title="filter"/><br/>
        <g:submitButton name="Filter" class="btn btn-primary"/>

    </g:form>

        <g:each in="${links}" var="currentLink">

            <div>
                ${currentLink.url}
            </div>

        </g:each>
    </p>
	</body>
</html>
