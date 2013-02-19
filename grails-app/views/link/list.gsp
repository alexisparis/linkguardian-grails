<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Link Guardian</title>
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
    span.description
    {
        font-size: smaller;
        line-heighta: 4px;
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
    div.linkpart[data-note="0"] span.rate
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
    legend {
        font-size: 17px !important;
        margin-bottom: 10px !important;
    }
        </style>
	</head>
	<body>

        <div class="nav nav-pills container" id="navigation" style="background-color: #ddd; margin-top: 3px; margin-bottom: 5px;"><!-- rgb(210, 225, 255); -->
            <div class="row">
                <div class="span5">

                    <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                                  method="POST" style="display: inline;"
                                  onSuccess="updateLinks(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)"> <!-- update="[success: 'message', failure: 'error']"  -->
                        <fieldset>
                            <legend>Search:</legend>
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
                                <g:textField id="filterInput" name="token" title="filter" placeholder="filter by tag" class="input-medium" maxlength="50"/>
                                <span class="add-on" id="clearFilterTag"><img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/></span>
                            </div>

                            <g:submitButton onclick="setSubmitFilterButtonToNormalState();" id="filter-input" name="Filter"
                                            class="btn btn-primary" style="background-image_old: url('${resource(dir: 'images', file: 'search.png')}')"/>
                        </fieldset>
                    </g:formRemote>
                </div>

                <div class="span7">
                    <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                                  method="POST" onSuccess="resetAddForm();submitFilterForm(); displayMessage(data);"
                                  onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)"
                                  style="margin-bottom: 3px;">        <fieldset>
                        <legend>Add a link:</legend>

                            <div class="input-prepend input-append" style="margin-bottom: 3px;">
                                <span class="add-on">url</span>
                                <input type="text" id="txtUrl" name="url" class="input-xxlarge" placeholder="http://..." maxlength="200"/> <%-- required="" --%>

                                <input class="btn btn-primary" type="submit" value="Add link"/>

                            </div>

                            <div>
                                <span class="label" style="vertical-align: top; margin-top: 6px;">Tags (Optional)</span> <%--a class="btn btn-info btn-mini" id="showTagInput">show</a--%>
                                <span>
                                    <g:textField id="txtTag" name="tag"
                                                 style="font-size: 13px; margin-bottom: 0px;"
                                                 class="input-xxlarge" placeholder="space separated tag names e.g. news travel ..." maxlength="100"/>
                                </span>
                            </div>
                        </fieldset>

                    </g:formRemote>
                </div>

            </div>
        </div>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.blockUI.js')}"></script>
        <%--script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script--%>

        <g:javascript>


            var reg = new RegExp("[ ,;]+", "g");

            function tagTemplate(tagNameRef)
            {
                return '<span class="tag btn btn-primary btn-mini" data-tag="{{' + tagNameRef + '}}">' +
                       '<button class="close deleteTagButton with-tooltip"' +
                       ' rel="tooltip" data-placement="top" data-original-title="Delete tag"' +
                       ' style="color: #fff;">&times;</button>' +
                       '<span class="with-tooltip" rel="tooltip" data-placement="top" data-original-title="filter on \'{{' + tagNameRef + '}}\'">{{' + tagNameRef + '}}</span>' +
                       '</span>';
            };

            function updateLinks(model)
            {
                var $container = $('#listing-part');

                //$('#listing-part').hide();
                $container.children().remove();

                $container.masonry('reload');

                //model._tags = model.tags.sort(compareTags);

                var _model = {
                    links : model.links,
                    _tags : function()
                    {
                        return this.tags.sort(compareTags)
                    }
                };

                var template =
                        '{{#links}}' +
                        '<div class="linkpart {{#read}}read{{/read}}" data-url="{{url}}" data-id="{{id}}" data-note={{note}}>' +
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
                        '{{#title}}<span class="title"><b>{{title}}</b></span><br/>{{/title}}' +
                        '{{#description}}<span class="description">{{description}}</span><br/>{{/description}}' +
                        '<span class="domain" style="font-size: 11px;"><i>{{domain}}</i></span>' +
                        '</div>' +
                        '<div class="tags">' +
                        '<i class="icon-tags" style="margin-right: 3px; margin-left: 6px;"></i>' +
                        '<span class="tags-wrapper">' +
                        '{{#_tags}}' +
                        tagTemplate('label') +
                        '{{/_tags}}' +
                        '</span>' +
                        '<span class="btn btn-primary btn-mini add-tag visible-on-hover">' +
                        '<i class="icon-plus-sign with-tooltip" rel="tooltip" data-original-title="add a new tag" data-placement="top"></i>' +
                        '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '{{/links}}';

                var output = Mustache.render(template, _model);

                $container.html(output);

                $('span.rate').each(function(idx, value)
                                    {
                                        var jValue = $(value);
                                        var jLinkPart = jValue.parents('div.linkpart').eq(0);
                                        var currentScore = parseInt(jLinkPart.attr('data-note'));
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

            function compareTags(a,b) {
                if (a.label < b.label)
                    return -1;
                if (a.label > b.label)
                    return 1;
                return 0;
            };

            function tagAdded(data)
            {
                var linkId = $('#addTagForm input[name="id"]').val();
                var tag = $('#addTagForm input[name="tag"]').val();
                if ( linkId )
                {
                    var jTagWrapperRef = $('div.linkpart[data-id="' + linkId + '"] div.tags span.tags-wrapper');

                    jTagWrapperRef.children().remove();

                    var template = tagTemplate('name');

                    data.tags.sort(compareTags);

                    for(var i = 0; i < data.tags.length; i++)
                    {
                        var output = Mustache.render(template, {
                            name : data.tags[i].label
                        });

                        $(output).appendTo(jTagWrapperRef);
                    }

                    displayMessage(data.message);
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
                               },4000);
                }
            };

            $(document).ready(
                    function()
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

                        // txtTag is now always displayed
                        /*$('#showTagInput').click(function(event)
                                                 {
                                                     $('#txtTag').fadeToggle({
                                                                                 easing: 'swing'
                                                                             });
                                                 });

                        $('#txtTag').fadeOut({
                                                 duration: 0
                                             });*/

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
                        $container.on('click', 'div.tags', goToLink);

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

        <g:javascript>
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

                                  $.fn.raty.defaults.path = '${resource(dir: 'images')}';
                              });
        </g:javascript>

        <div id="messageContainer" style="height: 38px; margin-top: 3px; margin-bottom: 3px;">
            <div id="message" ></div>
        </div>

        <div id="listing-part"></div>

        </div>

        <!-- ############# -->
        <!-- fictive forms -->
        <!-- ############# -->

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

        <!-- ####### -->
        <!-- dialogs -->
        <!-- ####### -->

        <div id="deleteLinkDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Add tags</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Mark as read?</h3>
            </div>
            <div class="modal-body">
                <p class="question"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();">Yes</button>
            </div>
        </div>

	</body>
</html>
