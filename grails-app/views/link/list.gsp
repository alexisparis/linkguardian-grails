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
        width: 307px;
        margin-right: 10px;
        margin-bottom: 10px;
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
        padding-right: 1px;
        padding-left: 5px;
    }
    button.close
    {
        margin-left: 10px;
        margin-right: 5px;
    }
    div.linkpart:not(hover) img.raty-cancel,
    div.linkpart:not(hover) .visible-on-hover
    {
        visibility: hidden;
    }
    div.linkpart:hover img.raty-cancel,
    div.linkpart:hover .visible-on-hover
    {
        visibility: visible;
    }
    button.deleteTagButton
    {
        margin-left: 1px;
        margin-right: 1px;
        margin-top: -3px;
    }
    div.linkpart:not(hover) .displayed-on-hover
    {
        display: none;
    }
    div.linkpart:hover .displayed-on-hover
    {
        display: inline-block;
    }
    span.tag:not(hover) button.deleteTagButton
    {
        visibility: hidden;
    }
    span.tag:hover button.deleteTagButton
    {
        visibility: visible;
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
                            '<div class="linkpart" data-url="{{url}}" data-id="{{id}}" data-note={{note.name}}>' +
                                '<div>' +
                                    '<img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" width="20px" height="20px" border="4px" style="margin-right: 2px; margin-bottom: 1px;"/>' +
                                    '<div class="rateAndClose">' +
                                        '<span class="rate"></span>' +
                                        //'<button class="archiveLinkButton with-tooltip" rel="tooltip" data-placement="top" data-original-title="Archive link">' +
                                        //    '<i class="icon-briefcase"></i>' +
                                        //'</button>' +
                                        //'<i class="icon-briefcase visible-on-hover"></i>' +
                                        '<button class="close deleteLinkButton with-tooltip visible-on-hover" rel="tooltip" data-placement="top" data-original-title="Delete link">&times;</button>' +
                                    '</div>' +
                                '</div>' +
                                '<div style="margin-top: 1px;word-wrap:break-word;">' +
                                    '<b>{{title}}</b><br/>{{description}}<br/>' +
                                    '<i class="domain" style="font-size: 11px;">{{domain}}</i><br/>' +
                                    '<div class="tags">' +
                                        '<i class="icon-tags" style="margin-right: 3px; margin-left: 6px;"></i>' +
                                        '{{#tags}}' +
                                            '<span class="tag btn btn-primary btn-mini">' +
                                                '<button class="close deleteTagButton with-tooltip"' +
                                                    ' rel="tooltip" data-placement="top" data-original-title="Delete tag"' +
                                                    ' style="color: #fff;">&times;</button>' +
                                                '{{.}}' +
                                            '</span>' +
                                        '{{/tags}}' +
                                        '<span class="tag-add btn btn-primary btn-mini add-tag displayed-on-hover">' +
                                            '<i class="icon-plus-sign with-tooltip" rel="tooltip" data-original-title="add new tag" data-placement="top"></i>' +
                                        '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '{{/links}}';

                var output = Mustache.render(template, model);

                $('#listing-part').html(output);

                $('span.rate').each(function(idx, value)
                                    {
                                       var jValue = $(value);
                                       var jLinkPart = jValue.parents('div.linkpart').eq(0);
                                       var currentScore = parseInt(jLinkPart.attr('data-note').substring(5));
                                       jValue.raty({
                                                       cancel: true,
                                                       size : 10,
                                                       score: currentScore,
                                                       click : function(score, evt) {
                                                           var oldScore = currentScore;
                                                           var linkId = parseInt(jLinkPart.attr('data-id'));

                                                           var jForm = $('#changeNoteForm');
                                                           jForm.find('input[name="id"]').val(linkId);
                                                           jForm.find('input[name="oldScore"]').val(oldScore);
                                                           jForm.find('input[name="newScore"]').val(score);

                                                           jForm.submit();
                                                       }
                                                    });
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

                $('.with-tooltip').tooltip();
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
                <a id="nav-archive">Tools</a>
            </li>
            <li style="margin-left: 40px;">
                <a href="#">About</a>
            </li>
            <li style="margin-left: 120px;">

                <!-- form used to delete a link -->
                <g:formRemote id="deleteLinkForm" name="deleteLinkForm" url="[controller: 'link', action: 'delete']"
                              method="POST" style="display: none;" onSuccess="linkDeletionConfirmed(data)" onFailure="displayStdError()">
                    <g:hiddenField name="id"/>
                </g:formRemote>


                <!-- form used to modify the rate a link -->
                <g:formRemote id="changeNoteForm" name="changeNoteForm" url="[controller: 'link', action: 'updateNote']"
                              method="POST" style="display: none;" onSuccess="noteUpdatedConfirmed(data)" onFailure="rollbackNoteUpdate()">
                    <g:hiddenField name="id"/>
                    <g:hiddenField name="oldScore"/>
                    <g:hiddenField name="newScore"/>
                </g:formRemote>

                <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                              method="POST" style="display: inline;"
                              onSuccess="updateLinks(data)"> <!-- update="[success: 'message', failure: 'error']"  -->
                    <fieldset>
                        <g:hiddenField name="archived" id="archived-input"/>
                        <label class="checkbox" style="margin-right: 10px;">
                            <input type="checkbox" name="read" id="read" value="read"/>
                                <i class="icon-eye-open"></i>&nbsp;read
                        </label>
                        <label class="checkbox" style="margin-right: 10px;">
                            <input type="checkbox" name="unread" id="unread" value="unread" checked>
                            <i class="icon-eye-close"></i>&nbsp;unread
                        </label>
                        <!--select name="sort">
                            <option value="date">sort by date</option>
                            <option value="rate">sort by rate</option>
                        </select-->
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
                var linkId = $('#deleteLinkForm input[name="id"]').val();
                if ( linkId )
                {
                    $('div.linkpart[data-id=' + linkId + ']').remove();
                    displayMessage(data);
                }
            };

            function noteUpdatedConfirmed(data)
            {
                var jForm = $('#changeNoteForm');
                $('div.linkpart[data-id="' + jForm.find('input[name="id"]').val() + '"]').attr('data-note', jForm.find('input[name="newScore"]').val());

                displayMessage(data);
            };

            function rollbackNoteUpdate()
            {
                var jForm = $('#changeNoteForm');
                var d = jForm.first('input[name="oldScore"]').val();
                $('div.linkpart[data-id="' + jForm.find('input[name="id"]').val() + '"] span.rate').raty('score', parseInt(jForm.find('input[name="oldScore"]').eq(0).val()));
                displayStdError();
            };

            function displayStdError()
            {
                displayMessage({
                   message : 'error',
                   level : {
                        name : "WARNING"
                   }
                });
            };

            function displayMessage(data)
            {
                var jObj = $('#message');
                jObj.fadeOut({
                    duration: 0
                });
                jObj.html('');
                jObj.attr('class', '');

                if( data )
                {
                    jObj.html(data.message);
                    jObj.addClass('label');
                    jObj.addClass('label-' + data.level.name.toLowerCase());
                    jObj.fadeIn({
                        duration: 0
                    });
                    setTimeout(function()
                    {
                        jObj.fadeOut({
                            duration: 1000
                        });
                    },3000);
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

                                  $('.with-tooltip').tooltip();
                              });
        </g:javascript>

        <div id="add-part">
            <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                          method="POST" onSuccess="resetAddForm();submitFilterForm(); displayMessage(data);">

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
        </div>

        <div id="messageContainer" style="height: 18px; margin-top: 3px; margin-bottom: 3px;">
            <div id="message" ></div>
        </div>

        <div id="listing-part"></div>

        </div>

        <g:javascript src="jquery.raty.js"/>
        <g:javascript src="jquery.masonry.js"/>

        <!-- dialogs -->
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
