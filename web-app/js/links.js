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
            '<div class="linkpart {{#read}}read{{/read}}" data-url="{{url}}" data-id="{{id}}" data-note={{note}}>' +
                '<div>' +
                    '<span class="linkUrl with-tooltip" rel="tooltip" data-placement="top" data-original-title="' + templateI18n.goto + ' {{domain}}">' +
                        '<img align="left" src="http://www.google.com/s2/favicons?domain={{domain}}" class="linkparticon"' +
                        'width="20px" height="20px" border="4px" style="margin-right: 2px; margin-bottom: 1px;"/>' +
                    '</span>' +
                    '<div class="rateAndOperations">' +
                        '<span class="rate"></span>' +
                            //'<button class="archiveLinkButton with-tooltip" rel="tooltip" data-placement="top" data-original-title="Archive link">' +
                            //    '<i class="icon-briefcase"></i>' +
                            //'</button>' +
                            //'<i class="icon-briefcase visible-on-hover"></i>' +
                        '<button class="close deleteLinkButton with-tooltip visible-on-hover" rel="tooltip" data-placement="left" data-original-title="' + templateI18n.deleteLink +'">&times;</button>' +
                        '<div style="clear: both;"></div>' +
                        '<div class="actions visible-on-hover" style="float: right; margin-right: 4px;">' +
                            '<a class="with-tooltip unread" rel="tooltip" data-placement="left" data-original-title="' + templateI18n.markAsUnread + '">' +
                                '<i class="icon icon-eye-close"></i>' +
                            '</a>' +
                            '<a class="with-tooltip read"   rel="tooltip" data-placement="left" data-original-title="' + templateI18n.markAsRead + '">' +
                                '<i class="icon icon-eye-open"></i>' +
                            '</a>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<div style="margin-top: 1px;word-wrap:break-word;">' +
                    '<div class="content with-tooltip" rel="tooltip" data-placement="top" data-original-title="' + templateI18n.goto + ' {{domain}}">' +
                        '{{#title}}<span class="title"><b>{{title}}</b></span><br/>{{/title}}' +
                        '{{#description}}<span class="description">{{description}}</span><br/>{{/description}}' +
                        '<span class="domain" style="font-size: 11px;"><i>{{domain}}</i></span>' +
                    '</div>' +
                    '<div class="tags with-tooltip">' + //</div> rel="tooltip" data-placement="top" data-original-title="' + templateI18n.goto + ' {{domain}}">' +
                        '<i class="icon-tags" style="margin-right: 3px; margin-left: 6px;"></i>' +
                        '<span class="tags-wrapper">' +
                            '{{#_tags}}' +
                                tagTemplate('label') +
                            '{{/_tags}}' +
                        '</span>' +
                        '<span class="btn btn-primary btn-mini add-tag visible-on-hover">' +
                            '<i class="icon-plus-sign with-tooltip" rel="tooltip" data-original-title="' + templateI18n.addTag + '" data-placement="top"></i>' +
                        '</span>' +
                    '</div>' +
                '</div>' +
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
              debug : true,
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

    // si j'appelle masonry sans delay, cela provoque la superposition de block
    // certainement du au fait que certaines initialisations (infinite-scroll, raty) ne sont
    // pas complètement terminés et du coup la détermination de la hauteur du block foire.
    // du coup, obligé d'ajouter un délai pour lancer masonry
    setTimeout(function()
               {
                   $container.masonry('appended', jOutput, true);

                   jOutput.fadeIn();
               }, 200);//2000);
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

        jTagWrapperRef.find('.with-tooltip').tooltip();

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

var permanentMessage = false;

function displayStdError()
{
    displayError(defaultErrorMessage);
};

function displayError(msg)
{
    displayMessage({
                       message : msg,
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
        if ( ! permanentMessage )
        {
            setTimeout(function()
                       {
                           jObj.fadeOut({
                                            duration: 1000
                                        });
                       },4000);
        }
    }
};

var markAsReadFormName = "markAsReadForm";
var markAsUnreadFormName = "markAsUnreadForm";

function markAsRead(linkId)
{
    changeReadability(linkId, markAsReadFormName)(null);//.call(this, null);
};

function markAsUnread(linkId)
{
    changeReadability(linkId, markAsUnreadFormName)(null);//.call(this, null);
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

$(document).ready(
    function()
    {
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

            console.log("href to set : " + href);

            anchor.attr('href', href);
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
            modalMarker.find('.question').html(markAsReadMessage + "<br/><b>" + jThis.find('.title').html() + "</b><br/>" + markAsReadFromMessage + " " + jThis.find('.domain').html() + " ?");
            modalMarker.modal();

            window.open(jThis.attr('data-url'),'_blank');
        };

        $container.on('click', 'div.content', goToLink);
        $container.on('click', 'img.linkparticon', goToLink);
        $container.on('click', 'div.tags', goToLink);

        $container.on('click', 'a.read', changeRead(true));
        $container.on('click', 'a.unread', changeRead(false));

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

        $('#showTagsCloud').on('click', function(event)
        {
            $('#showTagsCloudForm').submit();
        });
        $('#filterLinkForm select').on('change', function(event)
        {
            setSubmitFilterButtonToClickState();
        });

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