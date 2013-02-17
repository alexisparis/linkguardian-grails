

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

    var model = links;

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

$(document).ready(
    function()
    {
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