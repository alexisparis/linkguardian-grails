<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Link Guardian</title>
        <r:require modules="bootstrap"/>
        <r:require modules="mustache"/>

        <style type="text/css">

    #navigation
    {
        cursor: pointer;
    }
    div.linkpart
    {
        width: 270px;
        margin-right: 10px;
        float: left;
        background-color: #d2e1ff;/*#b2d1ff;*/
        border-radius: 5px 5px 5px;
        border: 1px solid #0081c2;
        padding: 2px;
        cursor: pointer;
    }
    div.linkpart:hover
    {
        /*background-color: #b2d1ff;*/
        background-color: #ccdbf9;
        box-shadow: #b0c4de 5px 5px 5px;
    }
    div.linkpart div.rateAndClose
    {
        float: right;
    }
    div.linkpart i.domain
    {
        color: #696969;
    }
    span.tag
    {
        border-radius: 5px 5px 5px;
        margin-right: 1px;
        margin-left: 1px;
        color: white;
        margin-bottom: 1px;
    }
    button.close
    {
        margin-left: 10px;
        margin-right: 5px;
    }
        </style>
	</head>
	<body>

    <g:javascript>

        var reg=new RegExp("[ ,;]+", "g");

        function updateLinks(links)
        {
            //$('#listing-part').hide();
            $('#listing-part').children().remove();

            var model = {
                'links' : links,
                'tags' : function()
                {
                    var trimmed = this.fusionedTags.trim();
                    if ( trimmed && trimmed.length > 0 )
                    {
                        return trimmed.toLowerCase().split(reg);
                    }
                    else
                    {
                        return undefined;
                    }
                }
            };

            var template =
                    '{{#links}}' +
                        '<div class="linkpart" data-url="{{url}}" data-id="{{id}}">' +
                            '<div>' +
                                '<img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" width="20px" height="20px" border="4px" style="margin-right: 1px; margin-bottom: 1px;"/>' +
                                '<div class="rateAndClose">' +
                                    '<span class="rate"></span>' +
                                    '<button class="close deleteLinkButton">&times;</button>' +
                                '</div>' +
                            '</div>' +
                            '<div style="margin-top: 1px;word-wrap:break-word;">' +
                                '<b>{{title}}</b><br/>{{description}}<br/>' +
                                '<i class="domain" style="font-size: 11px;">{{domain}}</i><br/>' +
                                '<div class="tags">' +
                                    '{{#tags}}<span class="tag btn btn-primary btn-mini">{{.}}</span>{{/tags}}' +
                                    '<span class="tag btn btn-primary btn-mini"><i class="icon-plus"></i></span>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '{{/links}}';

            var output = Mustache.render(template, model);

            $('#listing-part').html(output);

            $('span.rate').raty({
                                   cancel     : true,
                               });

            var $container = $('#listing-part');
            $container.imagesLoaded(function(){
                $container.masonry({
                                       itemSelector : 'a.link',
                                       columnWidth : function( containerWidth ) {
                                           return containerWidth / 3;
                                       },
                                       isAnimated: false
                                   });
            });

            //$('#listing-part').fadeIn();
        };

    </g:javascript>
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
        <li style="margin-left: 80px;">

            <!-- form used to delete a link -->
            <g:formRemote id="deleteLinkForm" name="deleteUrlForm" url="[controller: 'link', action: 'delete']"
                          method="POST" style="display: none;" onSuccess="linkDeletionConfirmed(data)">
                <g:hiddenField id="deleteUrlId" name="id"/>
            </g:formRemote>

            <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                          method="POST" style="display: inline;"
                          onSuccess="updateLinks(data)"> <!-- update="[success: 'message', failure: 'error']"  -->
                <fieldset>
                    <g:hiddenField name="archived" id="archived-input"/>
                    Sort
                    <select>
                        <option>by date</option>
                        <option>by rate</option>
                    </select>
                    <g:textField name="token" title="filter" placeholder="filter by tag" class="input-medium"/>
                    <g:submitButton id="filter-input" name="Filter" class="btn btn-primary" style="background-image_old: url('${resource(dir: 'images', file: 'search.png')}')"/>
                </fieldset>
            </g:formRemote>
        </li>
    </ul>

    <g:javascript>

        function submitFilterForm()
        {
            console.log("submitting filter form");
            $('#filterLinkForm').submit();
        };

        function deletionLink()
        {
            $('#deleteLinkForm').submit();
        };

        function resetAddForm()
        {
            $('#txtUrl').val('');$('#txtTag').val('');
        };

        function linkDeletionConfirmed(data)
        {
            var linkId = $('#deleteUrlId').val();
            if ( linkId )
            {
                $('div.linkpart[data-id=' + linkId + ']').remove();
            }
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

                              $.fn.raty.defaults.path = '${resource(dir: 'images')}';

                              $('#listing-part').on('click', 'button.deleteLinkButton', function(event)
                              {
                                  var linkId = $(event.target).parents('div.linkpart').eq(0).attr('data-id');
                                  if ( linkId )
                                  {
                                      $('#deleteUrlId').val(linkId);
                                      $('#deleteDialog').modal();
                                  }
                              });
                          });
    </g:javascript>

    <div id="add-part">
        <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                      method="POST" onSuccess="resetAddForm();submitFilterForm()">

            <div class="input-prepend input-append">
                <span class="add-on">url</span>
                <g:textField id="txtUrl" name="url" class="input-xxlarge" placeholder="http://..."/>

                <input class="btn btn-primary" type="submit" value="Add link"/>

            </div>

            <div>
                <span class="label">Tags (Optional)</span> <a class="btn btn-info btn-mini" id="showTagInput">show</a><br/>
                <div style="height: 20px; margin-top: 2px;">
                    <g:textField id="txtTag" name="tag" class="input-xxlarge" placeholder="Comma separated tag names e.g. news, technical, travel, leisure"/>
                </div>
            </div>

        </g:formRemote>


        <!--div id="message"/>
        <div id="error"/-->
    </div>

    <div id="listing-part">

    </div>

    </div>
    </p>

    <g:javascript src="jquery.raty.js"/>
    <g:javascript src="jquery.masonry.js"/>

    <!-- Modal -->
    <div id="deleteDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 id="myModalLabel">Confirmation</h3>
        </div>
        <div class="modal-body">
            <p>Do you really want to delete this link?</p>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
            <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true" onclick="deletionLink();">Yes</button>
        </div>
    </div>

	</body>
</html>
