<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Link Guardian</title>
        <r:require modules="bootstrap"/>
        <r:require modules="mustache"/>

        <
	</head>
	<body>
    <p>
        <openid:identifier />
    </p>
    <p>

    <ul class="nav nav-pills" id="navigation">
        <li class="active">
            <a id="nav-home">Home</a>
        </li>
        <li>
            <a id="nav-archive">Archive</a>
        </li>
        <li style="margin-left: 40px;">
            <a href="#">About</a>
        </li>
        <li style="margin-left: 280px;">

            <g:javascript>

                function updateLinks(links)
                {
                    $('#listing-part').children().remove();

                    var model = {
                        'links' : links
                    };

                    var template =
                        '{{#links}}' +
		                '<div class="linkpart"><img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" width="16px" height="16px" border="0"/>' +
                        '{{title}} <b>{{url}}</b></div>{{/links}}';

                    var output = Mustache.render(template, model);

                    $('#listing-part').html(output);
                };


            </g:javascript>

            <g:formRemote id="filter-form" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                          method="POST" style="display: inline;"
                          onSuccess="updateLinks(data)"> <!-- update="[success: 'message', failure: 'error']"  -->
                <fieldset>
                    <g:hiddenField name="archived" id="archived-input"/>
                    <g:textField name="token" title="filter" placeholder="filter" class="input-medium"/>
                    <g:submitButton id="filter-input" name="Filter" class="btn btn-primary" style="background-image_old: url('${resource(dir: 'images', file: 'search.png')}')"/>
                </fieldset>
            </g:formRemote>
        </li>
    </ul>

    <g:javascript>

        function submitFilterForm()
        {
            console.log("submitting filter form");
            $('#filter-form').submit();
        };

        function resetAddForm()
        {
            $('#txtUrl').val('');$('#txtTag').val('');
        };

        $(document).ready(function()
                          {
                              var callback = function(archived)
                              {
                                  return function(event)
                                  {
                                      $('#navigation > li').removeClass('active')
                                      $(this).parent().addClass('active')
                                      $('#archived-input').val(archived);
                                      submitFilterForm();
                                  };
                              }
                              $('#nav-home').click(callback(false));
                              $('#nav-archive').click(callback(true));

                              submitFilterForm();

                              $('#showTagInput').click(function(event)
                                                        {
                                                           $('#txtTag').fadeToggle({
                                                               easing: 'swing'
                                                                               });
                                                        });

                              $('#txtTag').fadeOut({
                                  duration: 0
                                                   });
                          });
    </g:javascript>

    <div id="add-part">
        <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                      method="POST" onSuccess="resetAddForm();submitFilterForm()">

            <div class="input-prepend input-append">
                <span class="add-on">url</span>
                <g:textField id="txtUrl" name="url" class="input-xxlarge"/>

                <input class="btn btn-primary" type="submit" value="Add link"/>

            </div>

            <div>
                <span class="label">Tags (Optional)</span> <a class="btn btn-info btn-mini" id="showTagInput">show</a><br/>
                <div style="height: 20px; margin-top: 2px;">
                    <g:textField id="txtTag" name="tag" class="input-xxlarge" placeholder="Comma separated tag names e.g. news, technical, travel, leisure"/>
                </div>
            </div>

        </g:formRemote>


        <div id="message"/>
        <div id="error"/>
    </div>

    <div id="listing-part">

    </div>

    </div>
    </p>
	</body>
</html>
