var reg = new RegExp("[ ,;]+", "g");

function tagTemplate(tagNameRef)
{
    return '<span class="tag btn btn-primary btn-mini" data-tag="{{' + tagNameRef + '}}">' +
           '<button class="close deleteTagButton with-tooltip"' +
           ' rel="tooltip" data-placement="top" data-original-title="' + templateI18n.deleteTag + '"' +
           ' style="color: #fff;">&times;</button>' +
           '<span class="with-tooltip" rel="tooltip" data-placement="top" data-original-title="' + templateI18n.filterOnTag + ' \'{{' + tagNameRef + '}}\'">{{' + tagNameRef + '}}</span>' +
           '</span>';
};

function jsonLinksToHtml(model)
{
    var _model = {
        links : model.links,
        _tags : function()
        {
            return this.tags.sort(compareTags)
        }
    };

    var template =
        '{{#links}}' +
            '<div class="linkpart ' + (showReadUnreadLink ? '{{#read}}read{{/read}}' : '') + '" data-url="{{url}}" data-id="{{id}}" data-note="{{note}}" data-readonly="{{readonly}}">' +
                '<div class="action-toolbar btn btn-primary btn-mini">' +
                    '<a class="with-tooltip unread" rel="tooltip" data-placement="bottom"' +
                        'data-original-title="marquer comme non lu">' +
                        '<i class="icon icon-eye-close icon-white"></i>' +
                    '</a>' +
                    '<a class="with-tooltip read" rel="tooltip" data-placement="bottom" data-original-title="marquer comme lu">' +
                        '<i class="icon icon-eye-open icon-white"></i>' +
                    '</a>' +
                    '<a class="importLinkButton with-tooltip" ' +
                        'rel="tooltip" data-placement="bottom" data-original-title="' + templateI18n.importLink +'">' +
                        '<i class="icon icon-plus icon-white"></i>' +
                    '</a>' +
                    '<a class="twitter with-tooltip" ' +
                        'rel="tooltip" data-placement="bottom" data-original-title="' + templateI18n.tweetLink +'">' +
                        '<img class="twitter-white" width="20px" height="20px">' +
                    '</a>' +
                    '<a class="deleteLinkButton with-tooltip" ' +
                        'rel="tooltip" data-placement="bottom" data-original-title="' + templateI18n.deleteLink +'"><i class="icon icon-remove icon-white"></i>' +
                    '</a>' +
                '</div>' +
                '<div>' +
                    '<div class="linkUrl with-tooltip" rel="tooltip" data-placement="right" data-original-title="' + templateI18n.goto + ' {{domain}}" style="height: 21px; width: 22px; float: left;">' +
                        '<img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" class="linkparticon"' +
                        'width="20px" height="20px" border="4px" style="margin-right: 2px; margin-bottom: 1px;"/>' +
                    '</div>' +
                    '{{^readonly}}' +
                    '<div class="rateAndOperations" style="width: 116; height: 16px;">' +
                        '<span class="rate"></span>' +
                    '</div>' +
                    '{{/readonly}}' +
                '</div>' +
                '<div style="margin-top: 1px;word-wrap:break-word;">' +
                    '<div class="content with-tooltip" rel="tooltip" data-placement="right" data-original-title="' + templateI18n.goto + ' {{domain}}">' +
                        '{{#title}}<span class="title" style="font-weight: bold;">{{title}}</span><br/>{{/title}}' +
                        '{{#description}}<span class="description">{{description}}</span><br/>{{/description}}' +
                        '<span class="domain" style="font-size: 11px;"><i>{{domain}}</i></span>' +
                    '</div>' +
                    '<div class="tags with-tooltip">' +
                        '<i class="icon-tags" style="margin-right: 3px; margin-left: 6px;"></i>' +
                        '<span class="tags-wrapper">' +
                            '{{#_tags}}' +
                                tagTemplate('label') +
                            '{{/_tags}}' +
                        '</span>' +
                        '{{^readonly}}' +
                            '<span class="btn btn-primary btn-mini add-tag visible-on-hover">' +
                                '<i class="icon-plus-sign with-tooltip icon-white" rel="tooltip" data-original-title="' + templateI18n.addTag + '" data-placement="top"></i>' +
                            '</span>' +
                        '{{/readonly}}' +
                    '</div>' +
                '</div>' +

                (showUserInLink ?
                 '<div style="float: right; height: 24px;" class="with-tooltip" rel="tooltip" data-placement="top" data-original-title="' + templateI18n.byTooltip + '">' +
                    '<a class="text-dark" href="' + rootUrl + 'profile/{{owner}}">' +
                        templateI18n.by + '&nbsp;' +
                        '<img class="twitter-account" data-twitter-name="{{owner}}" data-twitter-icon-size="mini"/>' +
                        '<span>&nbsp;{{owner}}</span>' +
                    '</a>' +
                 '</div>'
                 : '') +

            '</div>' +
        '{{/links}}';

    var output = Mustache.render(template, _model);

    return output;
};

function updateLinks(model)
{
    var $container = $('#listing-part');

    // https://github.com/paulirish/infinite-scroll/issues/88
    // http://stackoverflow.com/questions/7936270/jquery-infinite-scroll-reset
    $container.infinitescroll('destroy');
    $container.data('infinitescroll', null);

//    $container.children().remove();
//    $container.masonry('reload');
    if ( $container.children().length > 0 )
    {
        $container.masonry('remove', $container.children());
    }

    if ( model && model.links && model.links.length > 0 )
    {
        $('#no-result').hide();
    }
    else
    {
        $('#no-result').show();
    }

    //model._tags = model.tags.sort(compareTags);

    var output = jsonLinksToHtml(model);
    var jOutput = $(output);

    jOutput.hide();

    // todo : find a better solution to force masonry to reset the layout
    var data = $container.data('masonry');
    for(var i = 0; i < data.colYs.length; i++)
    {
        data.colYs[i] = 0
    }

    $container.append(jOutput);

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

    $container.infinitescroll({
              loading: {
                  selector: '#inf-scroll-load',
                  finishedMsg: infinitescrollFinishedMsg
                  ,img: infiniteScrollLoadImage
                  ,msgText: infinitescrollMsgText
              },
              debug : false,
              navSelector : '#nav-inf-scroll',
              nextSelector : '#nav-inf-scroll a',
              itemSelector : '#listing-part .linkpart',
              // other options
              dataType: 'json',
              appendCallback: false
          }
          ,function(json, opts)
          {
              var page = opts.state.currPage;

              var appended = $(jsonLinksToHtml(json));
              appended.css({ opacity: 0 });
              appended.imagesLoaded(function(){
                  // show elems now they're ready
                  $container.append(appended);
                  appended.animate({ opacity: 1});
                  $container.masonry('appended', appended, true);
              });
          }
    );

    $('#listing-part .with-tooltip').tooltip();
    includeTwitterLogo();
    includeTwitterAccountLogo();

    $container.masonry('appended', jOutput, true);

    jOutput.fadeIn();
};

function setSubmitFilterButtonToNormalState()
{
    $('#filter-input').removeClass("btn-warning").addClass("btn-primary");
    $('#shareLinksButton').removeClass('disabled');
};

function setSubmitFilterButtonToClickState()
{
    $('#filter-input').removeClass("btn-primary").addClass("btn-warning");
    $('#shareLinksButton').addClass('disabled');
};

function submitFilterForm()
{
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
        var toRemove = $('div.linkpart[data-id="' + linkId + '"]');
        if ( toRemove.size() > 0 )
        {
            toRemove.remove();
            $('#listing-part').masonry( 'reload' );
            displayMessage(data);
        }
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

        jTagWrapperRef.find('.with-tooltip').tooltip();

        $('#listing-part').masonry( 'reload' );

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
    displayMessage(data);
    submitFilterForm();
};

function markAsUnreadDone(data)
{
    var linkPart = $('div.linkpart[data-id="' + $('#markAsUnreadForm').find('input[name="id"]').eq(0).val() + '"]');
    linkPart.removeClass("read");
    displayMessage(data);
    submitFilterForm();
};

function showTagsCloud(data)
{
    console.log("show tags cloud");
    if ( data && data.length > 0 )
    {
        var jTagsCloud = $("#tagsCloud");

        var createHandler = function(tag)
        {
            return {
                click: function() {
                    $('#tagsCloudDialog').modal('hide');
                    $('#filterInput').val(tag);
                    submitFilterForm();
                }
            };
        };

        var array = []

        for(var i = 0; i < data.length; i++)
        {
            var current = data[i];
            var newTag = {
                text : current.tag,
                weight : current.weight,
                handlers : createHandler(current.tag)
            };
            array.push(newTag);
        }

        jTagsCloud.children().remove();
        var innerContainer = jTagsCloud.clone(); // take style property from jTagsCloud
        innerContainer.removeAttr('id'); // without its id
        innerContainer.appendTo(jTagsCloud);

        $('#tagsCloudDialog').modal();
        $('#tagsCloudDialog').on('shown', function ()
        {
            innerContainer.jQCloud(array);
        });
    }
    else
    {
        displayError(noTagsFoundError);
    }
};

var markAsReadFormName = "markAsReadForm";
var markAsUnreadFormName = "markAsUnreadForm";

function markAsRead(linkId)
{
    changeReadability(linkId, markAsReadFormName)(null);
};

function markAsUnread(linkId)
{
    changeReadability(linkId, markAsUnreadFormName)(null);
};

function changeReadability(linkId, formName)
{
    return function(event)
    {
        var form = $('#' + formName);
        form.find('input[name="id"]').val(linkId);
        form.submit();
    };
};

function markSelectedLinkAsRead()
{
    var id = $('div.linkpart.selected').attr('data-id');
    if ( id )
    {
        markAsRead(id);
    }
    else
    {
        displayStdError();
    }
};

function changeRead(read)
{
    var formName = null;

    if( read )
    {
        formName = markAsReadFormName;
    }
    else
    {
        formName = markAsUnreadFormName;
    }

    return function(event)
    {
        var linkId = $(this).parents('div.linkpart').eq(0).attr('data-id');
        var form = $('#' + formName);
        form.find('input[name="id"]').val(linkId);
        form.submit();
    }
};

function importDone(data)
{
   displayMessage(data);
};

function postTwitterStatus(status)
{
    window.open("https://twitter.com/home?status=" + status,'_blank');
};

$(document).ready(
    function()
    {
        /* mark search icon as to be clicked when modifications occurs */
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
        $('#filterLinkForm select').on('change', function(event)
        {
            setSubmitFilterButtonToClickState();
        });

        $('#filterLinkForm').on('submit', function(event)
        {
            // set the link for the anchor for infinite-scroll to work
            var anchor = $('#nav-inf-scroll a').first();

            var href = anchor.attr('data-filter-url-model');
            href = href + "?read_status=" + $('#read_status').val();
            href = href + "&sortBy=" + $('#sortBy').val();
            href = href + "&sortType=" + $('#sortType').val();
            href = href + "&token=" + encodeURIComponent($('#filterInput').val());
            href = href + "&page=2";
            href = href + "&linksofuser=" + $('#linksofuser').val();

            console.log("href to set : " + href);

            anchor.attr('href', href);
        });

        $('#listing-part').on('click', '.deleteLinkButton', function(event)
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

        /* Tags management */
        $container.on('click', 'span.tag', function(event)
        {
            event.stopPropagation();
            var jThis = $(this);
            var tag = jThis.attr('data-tag');
            $('#filterInput').val(tag);
            submitFilterForm();
        }).on('click', '.deleteTagButton', function(event)
        {
            event.stopPropagation();
            var jTag = $(this).parents('span.tag').eq(0);

            var jForm = $('#deleteTagForm');
            jForm.find('input[name="id"]').val(jTag.parents('div.linkpart').eq(0).attr("data-id"));
            jForm.find('input[name="tag"]').val(jTag.attr("data-tag"));

            $('#deleteTagDialog').modal();
        }).on('click', '.add-tag', function(event)
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

        /* go to link */
        var goToLink = function(event)
        {
            event.stopPropagation();
            $('div.linkpart').removeClass('selected');
            var jThis = $(this).parents('div.linkpart').eq(0);
            jThis.addClass('selected');

            console.log("data-readonly : " + jThis.attr("data-readonly"));
            if ( jThis.attr("data-readonly") === 'false' && !jThis.hasClass('read') )  // not readonly and not already read
            {
                var modalMarker = $('#markAsReadDialog');
                modalMarker.find('span.img').html(jThis.find('span.linkUrl').html());
                modalMarker.find('.question').html(markAsReadMessage + "<br/><b>" + jThis.find('.title').html() + "</b><br/>" + markAsReadFromMessage + " " + jThis.find('.domain').html() + " ?");
                modalMarker.modal();
            }

            window.open(jThis.attr('data-url'),'_blank');
        };

        $container.on('click', 'div.content', goToLink);
        $container.on('click', 'img.linkparticon', goToLink);
        $container.on('click', 'div.tags', goToLink);

        /* actions */
        $container.on('click', '.action-toolbar .read', changeRead(true));
        $container.on('click', '.action-toolbar .unread', changeRead(false));

        $container.on('click', '.action-toolbar .twitter', function(event)
        {
            var linkpart = $(this).parents('div.linkpart').eq(0);
            if ( linkpart )
            {
                var message = "";
                var title = linkpart.find('.title');
                // title
                if ( title )
                {
                    message = message + title.text() + " ";
                }
                //tags
                linkpart.find('span.tag').each(function(index, value)
                {
                    message = message + "#" + $(value).attr('data-tag') + " ";
                });

                message = message + linkpart.attr('data-url');

                postTwitterStatus(encodeURIComponent(message));
            }
        });
        $container.on('click', '.action-toolbar .importLinkButton', function(event)
        {
            // modify form and submit it
            var jForm = $('#importLink');
            jForm.find('input[name="id"]').val($(this).parents('div.linkpart').eq(0).attr('data-id'));
            jForm.submit();
        });

        /* tags of cloud */
        $('#showTagsCloud').on('click', function(event)
        {
            $('#showTagsCloudForm').submit();
        });

        $('#shareLinksButton').on('click', function(event)
        {
            if ( ! $('#shareLinksButton').hasClass('disabled') )
            {
                // test if there are links
                var linksCount = $('#listing-part .linkpart').size();

                if ( linksCount == 0 )
                {
                    $('#shareImpossibleCauseNoLinksDialog').modal();
                }
                else
                {
                    // if my configuration is all locked, warn user that hte configuration must be modified
                    if ( $('#allLinksPrivate').val() === 'true' )
                    {
                        $('#shareWarningDueToPrivacyDialog').modal();
                    }
                    else
                    {
                        // build an url to twitter.com to start creating a new tweet
                        var tags = $('#filterInput').val();
                        var _tags = "";
                        var tagsArray;
                        if ( tags )
                        {
                            tags = $.trim(tags);
                            tagsArray = tags.split(" ");
                        }

                        var message = "my links";
                        if ( tagsArray )
                        {
                            message = message + " about";
                            for(var i = 0; i < tagsArray.length; i++)
                            {
                                var current = tagsArray[i];
                                if ( current )
                                {
                                    current = $.trim(current);
                                    if ( current.length > 0 )
                                    {
                                        message = message + " #" + current;

                                        if ( _tags.length == 0 )
                                        {
                                            _tags = current;
                                        }
                                        else
                                        {
                                            _tags = _tags + " " + current;
                                        }

                                    }
                                }
                            }
                        }

                        var url = "https://linkguardian-blackdog.rhcloud.com/" + $('#linksofuser').val() + (_tags.length == 0 ? "" : "/" + _tags);

                        // shorten url
                        shortenUrl(url, function(data)
                        {
                            console.log("calling callback with " + data);

                            message = message + " " + data;
                            message = message + " (via @linkguardian)";

                            console.log("message : " + message);
                            console.log("encoded : " + encodeURIComponent(message));

                            postTwitterStatus(encodeURIComponent(message));
                        });
                    }
                }
            }
        });

        /* focus management */

        // when return on linkguardian, if no input has focus, then set focus to txtUrl
        $(window).focus(function() {
            console.log('Focus');
            var element = document.querySelector(":focus");
            if ( ! element )
            {
                $('#txtUrl').focus();
            }
        });

        $('#txtUrl').focus();
    });