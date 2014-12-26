function displayFailure(XMLHttpRequest,textStatus,errorThrown)
{
    if ( XMLHttpRequest )
    {
        if ( XMLHttpRequest.status == 0 )
        {
            displayCommunicationError();
        }
        else if ( XMLHttpRequest.responseText && XMLHttpRequest.responseText.length  )
        {
            try
            {
                var message = JSON.parse(XMLHttpRequest.responseText);
                displayMessage(message);
            }
            catch(err)
            {
                displayStdError();
            }
        }
        else
        {
            displayStdError();
        }
    }
    else
    {
        displayStdError();
    }
};

function scrollToTop()
{
    // scroll to top
    $('html, body').animate({scrollTop:0}, 'slow');
};

var permanentMessage = false;

function displayStdError()
{
    displayError(defaultErrorMessage);
};

function displayCommunicationError()
{
    displayError(communicationErrorMessage);
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
        scrollToTop();

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

$(document).ready(function()
                  {
                      // key bindings on modal twitter bootstrap dialogs
                      $('div.modal').bind('keydown', function(event)
                      {
                          $(this).find('button[data-key=' + event.which + ']').trigger('click');
                      });
                  });



function includeTwitterAccountLogo()
{
    // https://dev.twitter.com/docs/api/1/get/users/profile_image/%3Ascreen_name
    // bigger normal mini
    $('img.twitter-account:not(.included)').each(function(index, value)
                                                         {
                                                             var $value = $(value);
                                                             var size = 'mini';
                                                             var sizeAttr = $value.attr('data-twitter-icon-size');
                                                             if ( sizeAttr )
                                                             {
                                                                size = sizeAttr;
                                                             }

                                                             var success = function(data, textStatus, jqXHR)
                                                             {
                                                                 if ( data )
                                                                 {
                                                                     var profileImageUrl = data.profile_image_url;
                                                                     $value.attr('src', profileImageUrl);
                                                                     //$value.attr('src', 'https://api.twitter.com/1/users/profile_image?screen_name=' + $value.attr('data-twitter-name') + '&size=' +size);
                                                                 }
                                                             };

                                                             $value.addClass('included');


                                                             $.jsonp({
                                                                 "url":'https://api.twitter.com/1.1/users/show.json?' +
                                                                     'callback=_jqjsp' +
                                                                     '&screen_name=' + $value.attr('data-twitter-name'),
                                                                 "success": success,
                                                                 "error": function(d,msg) {
                                                                     console.error("Could not load the twitter profile of " + accounts.twitter + " (rejected ? " + d.isRejected() + ")");

                                                                     // show error
                                                                     setTimeout(showTwitterThresholdMessage, 100);
                                                                 }
                                                             });

                                                             /*$.ajax({
                                                                 dataType: "jsonp",
                                                                 url: 'https://api.twitter.com/1.1/users/show.json?screen_name=' + $value.attr('data-twitter-name'),
                                                                 data: '',
                                                                 success: success
                                                             });*/

                                                             // https://dev.twitter.com/docs/user-profile-images-and-banners
                                                             // https://dev.twitter.com/docs/api/1.1/get/users/show
                                                             //https://api.twitter.com/1.1/users/show.json?screen_name=paris_alex
                                                         });
};


