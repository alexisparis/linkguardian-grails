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
        float: left;
        margin-right: 10px;
        margin-bottom: 10px;
        background-color: #d2e1ff;
        border-radius: 5px 5px 5px;
        border: 1px solid #0081c2;
        padding: 2px;
        cursor: pointer;
    }
    div.linkpart.read
    {
        background-color: #ddd;
        border-radius: 5px 5px 5px;
        border: 1px solid #888;
    }
    div.linkpart.read:hover
    {
        /*box-shadow: #ccc 5px 5px 5px;*/
    }
    div.linkpart.selected:not(.read)
    {
        background-color: #accdf6;
        border: 1px solid #002a80;
    }
    div.linkpart.selected:hover:not(.read)
    {
        background-color: #accdf6;
        /*box-shadow: #b0c4de 5px 5px 5px;*/
    }
    div.linkpart:hover:not(.read)
    {
        background-color: #ccdbf9;
        /*box-shadow: #b0c4de 5px 5px 5px;*/
    }
    div.linkpart div.rateAndOperations
    {
        float: right;
    }
    div.linkpart .domain
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
        opacity: 0.6;
    }
    div.linkpart:not(hover) .displayed-on-hover
    {
        display: none;
    }
    div.linkpart:hover .displayed-on-hover
    {
        display: inline-block;
    }
    div.tags /* used to isplay tags with a scroll if a tag name is too long */
    {
        overflow:auto;
    }
    span.tag:not(hover) button.deleteTagButton
    {
        visibility: hidden;
    }
    span.tag:hover button.deleteTagButton
    {
        visibility: visible;
    }
    div.linkpart[data-note=Note_0] span.rate
    {
        visibility: hidden;
    }
    div.linkpart:hover span.rate
    {
        visibility: visible;
    }
    div.linkpart.read .read
    {
        display: none;
    }
    div.linkpart:not(.read) .unread
    {
        display: none;
    }
    div.actions .icon
    {
        opacity: 0.3;
    }
    div.actions:hover .icon
    {
        opacity: 0.7;
    }
        </style>
	</head>
	<body>

        <g:javascript>

            var reg = new RegExp("[ ,;]+", "g");

            function tagTemplate(tagNameRef)
            {
                return '<span class="tag btn btn-primary btn-mini" data-tag="{{' + tagNameRef + '}}">' +
                        '<button class="close deleteTagButton with-tooltip"' +
                            ' rel="tooltip" data-placement="top" data-original-title="Delete tag"' +
                            ' style="color: #fff;">&times;</button>' +
                            '{{' + tagNameRef + '}}' +
                       '</span>';
            };

            function updateLinks(links)
            {
                var $container = $('#listing-part');

                //$('#listing-part').hide();
                $container.children().remove();

                $container.masonry('reload');

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
                            '<div class="linkpart {{#read}}read{{/read}}" data-url="{{url}}" data-id="{{id}}" data-note={{note.name}}>' +
                                '<div>' +
                                    '<span class="linkUrl with-tooltip" rel="tooltip" data-placement="top" data-original-title="go to {{domain}}">' +
                                        '<img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" class="linkparticon"' +
                                            'width="20px" height="20px" border="4px" style="margin-right: 2px; margin-bottom: 1px;"/>' +
                                    '</span>' +
                                    '<div class="rateAndOperations">' +
                                        '<span class="rate"></span>' +
                                        //'<button class="archiveLinkButton with-tooltip" rel="tooltip" data-placement="top" data-original-title="Archive link">' +
                                        //    '<i class="icon-briefcase"></i>' +
                                        //'</button>' +
                                        //'<i class="icon-briefcase visible-on-hover"></i>' +
                                        '<button class="close deleteLinkButton with-tooltip visible-on-hover" rel="tooltip" data-placement="top" data-original-title="Delete link">&times;</button>' +
                                        '<div style="clear: both;"></div>' +
                                        '<div class="actions visible-on-hover" style="float: right; margin-right: 4px;">' +
                                            '<a class="with-tooltip unread" rel="tooltip" data-placement="top" data-original-title="mark as unread"><i class="icon icon-eye-close"></i></a>' +
                                            '<a class="with-tooltip read"   rel="tooltip" data-placement="top" data-original-title="mark as read"><i class="icon icon-eye-open"></i></a>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                                '<div style="margin-top: 1px;word-wrap:break-word;">' +
                                    '<div class="content with-tooltip" rel="tooltip" data-placement="top" data-original-title="go to {{domain}}">' +
                                        '<span class="title"><b>{{title}}</b></span><br/><span class="description">{{description}}</span><br/>' +
                                        '<span class="domain" style="font-size: 11px;"><i>{{domain}}</i></span>' +
                                    '</div>' +
                                    '<div class="tags">' +
                                        '<i class="icon-tags" style="margin-right: 3px; margin-left: 6px;"></i>' +
                                        '{{#tags}}' +
                                            tagTemplate('.') +
                                        '{{/tags}}' +
                                        '<span class="btn btn-primary btn-mini add-tag visible-on-hover">' +
                                            '<i class="icon-plus-sign with-tooltip" rel="tooltip" data-original-title="add new tag" data-placement="top"></i>' +
                                        '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '{{/links}}';

                var output = Mustache.render(template, model);

                $container.html(output);

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

                $container.masonry('appended', $(output), true);

                //TODO

                $('.with-tooltip').tooltip();
                //$('#listing-part').fadeIn();
            };

        </g:javascript>
        <p>
            <openid:identifier />
        </p>
        <p>

        <ul class="nav nav-pills" id="navigation">
            <li>
                <!-- form used to delete a link -->
                <g:formRemote id="deleteLinkForm" name="deleteLinkForm" url="[controller: 'link', action: 'delete']"
                              method="POST" style="display: none;" onSuccess="linkDeletionConfirmed(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                </g:formRemote>

                <!-- form used to delete a tag -->
                <g:formRemote id="deleteTagForm" name="deleteTagForm" url="[controller: 'link', action: 'deleteTag']"
                              method="POST" style="display: none;" onSuccess="tagDeletionConfirmed(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                    <g:hiddenField name="tag"/>
                </g:formRemote>

                <!-- form used to add a tag -->
                <g:formRemote id="addTagForm" name="addTagForm" url="[controller: 'link', action: 'addTag']"
                              method="POST" style="display: none;" onSuccess="tagAdded(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                    <g:hiddenField name="tag"/>
                </g:formRemote>

                <!-- form used to modify the rate a link -->
                <g:formRemote id="changeNoteForm" name="changeNoteForm" url="[controller: 'link', action: 'updateNote']"
                              method="POST" style="display: none;" onSuccess="noteUpdatedConfirmed(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                    <g:hiddenField name="oldScore"/>
                    <g:hiddenField name="newScore"/>
                </g:formRemote>

                <!-- form used to modify the read attribute a link -->
                <g:formRemote id="markAsReadForm" name="markAsReadForm" url="[controller: 'link', action: 'markAsRead']"
                              method="POST" style="display: none;" onSuccess="markAsReadDone(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                </g:formRemote>
                <g:formRemote id="markAsUnreadForm" name="markAsUnreadForm" url="[controller: 'link', action: 'markAsUnread']"
                              method="POST" style="display: none;" onSuccess="markAsUnreadDone(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:hiddenField name="id"/>
                </g:formRemote>

                <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                              method="POST" style="display: inline;"
                              onSuccess="updateLinks(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)"> <!-- update="[success: 'message', failure: 'error']"  -->
                    <fieldset>
                        <!--g:hiddenField name="archived" id="archived-input"/-->
                        <label class="checkbox read-check" style="margin-right: 10px;">
                            <input class="read-marker" type="checkbox" name="read" id="read" value="read"/>
                                <i class="icon-eye-open"></i>&nbsp;read
                        </label>
                        <label class="checkbox read-check" style="margin-right: 10px;">
                            <input class="read-marker" type="checkbox" name="unread" id="unread" value="unread" checked>
                            <i class="icon-eye-close"></i>&nbsp;unread
                        </label>
                        <!--select name="sort">
                            <option value="date">sort by date</option>
                            <option value="rate">sort by rate</option>
                        </select-->

                        <div class="input-append">
                            <g:textField id="filterInput" name="token" title="filter" placeholder="filter by tag" class="input-medium"/>
                            <span class="add-on" id="clearFilterTag"><img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/></span>
                        </div>

                        <g:submitButton onclick="setSubmitFilterButtonToNormalState();" id="filter-input" name="Filter" class="btn btn-primary" style="background-image_old: url('${resource(dir: 'images', file: 'search.png')}')"/>
                    </fieldset>
                </g:formRemote>
            </li>
            <li style="float: right;">
                <button class="btn" id="about">About</button>
            </li>
        </ul>

        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.blockUI.js')}"></script>
        <%--g:javascript src="jquery.raty.js" />
        <g:javascript src="jquery.masonry.min.js"/>
        <g:javascript src="jquery.blockUI.js"/--%>

        <g:javascript>

            function setSubmitFilterButtonToNormalState()
            {
                $('#filter-input').removeClass("btn-warning").addClass("btn-primary");
            };

            function setSubmitFilterButtonToClickState()
            {
                $('#filter-input').removeClass("btn-primary").addClass("btn-warning");
            };

            function submitFilterForm()
            {
                console.log("submitting filter form");
                $('#filterLinkForm').submit();
            };

            function deleteLink()
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
                    $('div.linkpart[data-id="' + linkId + '"]').remove();
                    displayMessage(data);
                }
            };

            function deleteTag()
            {
                $('#deleteTagForm').submit();
            };

            function tagDeletionConfirmed(data)
            {
                var linkId = $('#deleteTagForm input[name="id"]').val();
                var tag = $('#deleteTagForm input[name="tag"]').val();
                if ( linkId )
                {
                    $('div.linkpart[data-id="' + linkId + '"] span.tag[data-tag="' + tag + '"]').remove();
                    displayMessage(data);
                }
                submitFilterForm();
            };

            function addTag()
            {
                $('#addTagForm input[name="tag"]').val($('#newTagInput').val());
                $('#addTagForm').submit();
            };

            function tagAdded(data)
            {
                var linkId = $('#addTagForm input[name="id"]').val();
                var tag = $('#addTagForm input[name="tag"]').val();
                if ( linkId )
                {
                    var jAddTagRef = $('div.linkpart[data-id="' + linkId + '"] div.tags span.add-tag');

                    var output = Mustache.render(tagTemplate('name'), {
                        name : tag
                    });

                    $(output).insertBefore(jAddTagRef);

                    displayMessage(data);
                }
            };

            function noteUpdatedConfirmed(data)
            {
                var jForm = $('#changeNoteForm');
                var note = jForm.find('input[name="newScore"]').val();
                 if(!note)
                 {
                    note = 0;
                 }
                 note = "Note_" + note;
                $('div.linkpart[data-id="' + jForm.find('input[name="id"]').val() + '"]').attr('data-note', note);

                displayMessage(data);
            };

            function rollbackNoteUpdate()
            {
                var jForm = $('#changeNoteForm');
                var d = jForm.first('input[name="oldScore"]').val();
                $('div.linkpart[data-id="' + jForm.find('input[name="id"]').val() + '"] span.rate').raty('score', parseInt(jForm.find('input[name="oldScore"]').eq(0).val()));
                displayStdError();
            };

            function markAsReadDone(data)
            {
                var linkPart = $('div.linkpart[data-id="' + $('#markAsReadForm').find('input[name="id"]').eq(0).val() + '"]');
                linkPart.addClass("read");
                //TODO : remove from masonry if read non coché
                displayMessage(data);
                submitFilterForm();
            };

            function markAsUnreadDone(data)
            {
                var linkPart = $('div.linkpart[data-id="' + $('#markAsUnreadForm').find('input[name="id"]').eq(0).val() + '"]');
                linkPart.removeClass("read");
                //TODO : remove from masonry if unread non coché
                displayMessage(data);
                submitFilterForm();
            };

            function displayFailure(XMLHttpRequest,textStatus,errorThrown)
            {
                if ( XMLHttpRequest && XMLHttpRequest.responseText && XMLHttpRequest.responseText.length )
                {
                    var message = JSON.parse(XMLHttpRequest.responseText);
                    displayMessage(message);
                }
                else
                {
                    displayStdError();
                }
            };

            function displayStdError()
            {
                displayMessage({
                   message : 'error',
                   level : {
                        name : "ERROR"
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
                    jObj.addClass('alert');
                    jObj.addClass('alert-' + data.level.name.toLowerCase());
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
                                  $(document).ajaxStart(function(){
                                                $.blockUI(
                                                    {
                                                        message : '<img src="${resource(dir: "images/loading", file: "loading_big.gif")}"/>',
                                                        css: {
                                                            border: 'none',
                                                            backgroundColor: 'none',
                                                            opacity:         0.8
                                                            }
                                                    }
                                                );
                                            })
                                             .ajaxStop(function(){
                                                setTimeout(function(){
                                                    $.unblockUI();
                                                }, 200); //TODO : reduce additional times
                                            });

                                  $('#about').on('click', function(event)
                                  {
                                    $('#aboutDialog').modal();
                                  });

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
                                      event.stopPropagation();
                                      var linkId = $(event.target).parents('div.linkpart').eq(0).attr('data-id');
                                      if ( linkId )
                                      {
                                        var jForm = $('#deleteLinkForm');
                                        jForm.find('input[name="id"]').val(linkId);
                                        $('#deleteLinkDialog').modal();
                                      }
                                  });

                                  $('.with-tooltip').tooltip();

                                  var $container = $('#listing-part');
                                  $container.imagesLoaded(function(){

                                      $container.masonry({
                                                             itemSelector : 'a.link',
                                                             columnWidth : function( containerWidth ) {
                                                                 return (containerWidth) / 3;
                                                             }
                                                         });

                                      submitFilterForm();
                                  });

                                  $container.on('click', 'span.tag', function(event)
                                  {
                                    event.stopPropagation();
                                    var jThis = $(this);
                                    var tag = jThis.attr('data-tag');
                                    $('#filterInput').val(tag);
                                    submitFilterForm();
                                  });


                                  $container.on('click', 'button.deleteTagButton', function(event)
                                  {
                                    event.stopPropagation();
                                    var jTag = $(this).parents('span.tag').eq(0);

                                    var jForm = $('#deleteTagForm');
                                    jForm.find('input[name="id"]').val(jTag.parents('div.linkpart').eq(0).attr("data-id"));
                                    jForm.find('input[name="tag"]').val(jTag.attr("data-tag"));

                                    $('#deleteTagDialog').modal();
                                  });

                                  $container.on('click', 'span.add-tag', function(event)
                                  {
                                     event.stopPropagation();

                                    var jForm = $('#addTagForm');
                                    jForm.find('input[name="id"]').val($(this).parents('div.linkpart').eq(0).attr("data-id"));

                                    $('#newTagInput').val('');
                                    $('#addTagDialog').modal();
                                    setTimeout(function()
                                    {
                                        $('#newTagInput').focus();
                                    }, 1000);
                                  });

                                  // key bindings on modal twitter bootstrap dialogs
                                  $('div.modal').on('keydown', function(event)
                                  {
                                    $(this).find('button[data-key|=' + event.which + ']').trigger('click');
                                  });

                                  var goToLink = function(event)
                                  {
                                     event.stopPropagation();
                                     $('div.linkpart').removeClass('selected');
                                     var jThis = $(this).parents('div.linkpart').eq(0);
                                     jThis.addClass('selected');

                                     var modalMarker = $('#markAsReadDialog');
                                     modalMarker.find('span.img').html(jThis.find('span.linkUrl').html());
                                     modalMarker.find('.question').html("Do you want to mark as read the link<br/><b>" + jThis.find('.title').html() + "</b><br/>from " + jThis.find('.domain').html() + " ?");
                                     modalMarker.modal();

                                     window.open(jThis.attr('data-url'),'_blank');
                                  };

                                  $container.on('click', 'div.content', goToLink);
                                  $container.on('click', 'img.linkparticon', goToLink);

                                  var changeRead = function(read, formName)
                                  {
                                    return function(event)
                                    {
                                        var linkId = $(this).parents('div.linkpart').eq(0).attr('data-id');
                                        var form = $('#' + formName);
                                        form.find('input[name="id"]').val(linkId);
                                        form.submit();
                                    };
                                  };

                                  $container.on('click', 'a.read', changeRead(true, "markAsReadForm"));
                                  $container.on('click', 'a.unread', changeRead(false, "markAsUnreadForm"));

                                  $('input.read-marker').on('click', function(event)
                                   {
                                      setSubmitFilterButtonToClickState();
                                   });
                                  $('#filterInput').on('keypress', setSubmitFilterButtonToClickState);


                                  $('#clearFilterTag').on('click', function(event)
                                  {
                                     var inputFilter = $('#filterInput');
                                      var val = inputFilter.val();
                                     if ( val && val.length > 0 )
                                     {
                                        inputFilter.val('');
                                        setSubmitFilterButtonToClickState();
                                     }
                                  });

                              });
        </g:javascript>

        <div id="add-part">
            <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                          method="POST" onSuccess="resetAddForm();submitFilterForm(); displayMessage(data);"
                          onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">

                <div class="input-prepend input-append">
                    <span class="add-on">url</span>
                    <g:textField id="txtUrl" name="url" class="input-xxlarge" placeholder="http://..." required=""/>

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

        <div id="messageContainer" style="height: 38px; margin-top: 3px; margin-bottom: 3px;">
            <div id="message" ></div>
        </div>

        <div id="listing-part"></div>

        </div>

        <!-- dialogs -->
        <div id="deleteLinkDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
            </div>
            <div class="modal-body">
                <p>Do you really want to delete this link?</p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteLink();">Yes</button>
            </div>
        </div>
        <div id="deleteTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
            </div>
            <div class="modal-body">
                <p>Do you really want to delete this tag?</p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteTag();">Yes</button>
            </div>
        </div>
        <div id="addTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Add a new tag</h3>
            </div>
            <div class="modal-body" style="text-align: center;">
                <g:textField id="newTagInput" name="name" class="input-xlarge"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="addTag();">Yes</button>
            </div>
        </div>
        <div id="markAsReadDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Mark as read?</h3>
            </div>
            <div class="modal-body">
                <p class="question"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();">Yes</button>
            </div>
        </div>
    <div id="aboutDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>
                <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> About Link Guardian</h3>
        </div>
        <div class="modal-body">
            <p>Link Guardian is a tool that allow to <span class="label label-success">register websites adress</span>.</p>
            <p>It is especially designed to manage articles that you want to <span class="label label-success">read later</span> or if you want to collect a set of articles related to the same subject.</p>
            <p>Each link registered can be <u>tagged</u>, <u>marked as read or unread</u> or <u>removed</u> if the content of an article is not interesting enough.</p>
            <p style="margin-top: 30px;"><strong>Link Guardian allows you to <span class="label label-success">bookmark websites</span> that you like and helps you <span class="label label-success">never forget to read an attractive article</span>.</strong></p>

        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true">Close</button>
        </div>
    </div>

	</body>
</html>
