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
            var message = JSON.parse(XMLHttpRequest.responseText);
            displayMessage(message);
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
                      $('div.modal').on('keydown', function(event)
                      {
                          $(this).find('button[data-key|=' + event.which + ']').trigger('click');
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
                                                             $value.attr('src', 'https://api.twitter.com/1/users/profile_image?screen_name=' + $value.attr('data-twitter-name') + '&size=' +size);
                                                             $value.addClass('included');
                                                         });
};



