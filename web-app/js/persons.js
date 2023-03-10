
function jsonPersonsToHtml(_persons)
{
    var model = {
        persons : _persons,
        "hasLinks": function () {
            return this.linksCount > 0;
        }

    };

    var template =
        '{{#persons}}' +
            '<div class="personpart with-tooltip" data-username="{{username}}" data-links-count="{{linksCount}}" style="" ' +
                'rel="tooltip" data-placement="left" data-original-title="' + personsLinksGoToTooltip + '"' +
                'data-link-url="' + rootUrl + 'profile/{{username}}">' +
                '<span style="float: left; height: 73px; width: 73px; margin-top: 5px; margin-bottom: 5px; margin-left: 5px;">' +
                    '<img class="twitter-account" data-twitter-name="{{username}}" data-twitter-icon-size="bigger"/>' +
                '</span>' +
                '<span style="line-height: 73px; margin-left: 5px; font-size: large; vertical-align: middle;">{{username}}</span>' +
                '<span style="float: right">{{linksCount}} ' + linkLabel + '{{#hasLinks}}s{{/hasLinks}}</span>' +
            '</div>' +
        '{{/persons}}';

    var output = Mustache.render(template, model);

    return output;
};

function updatePersons(persons)
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
        if ( $container.data('masonry') )
        {
            $container.masonry('remove', $container.children());
        }
    }

    if ( persons && persons.length > 0 )
    {
        $('#no-result').hide();
    }
    else
    {
        $('#no-result').show();
    }

    //model._tags = model.tags.sort(compareTags);

    var output = jsonPersonsToHtml(persons);
    var jOutput = $(output);

    jOutput.hide();

    // todo : find a better solution to force masonry to reset the layout
    var data = $container.data('masonry');
    if ( data )
    {
        for(var i = 0; i < data.colYs.length; i++)
        {
            data.colYs[i] = 0
        }
    }

    $container.append(jOutput);

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
              itemSelector : '#listing-part .personpart',
              // other options
              dataType: 'json',
              appendCallback: false
          }
          ,function(json, opts)
          {
              var page = opts.state.currPage;

              var appended = $(jsonPersonsToHtml(json));
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

    if ( data )
    {
        $container.masonry('appended', jOutput, true);
    }

    jOutput.fadeIn();
};

$(document).ready(
    function()
    {
        $('.with-tooltip').tooltip();

        var $container = $('#listing-part');
    });