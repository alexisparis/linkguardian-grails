


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

$(document).ready(function()
                  {
                      // key bindings on modal twitter bootstrap dialogs
                      $('div.modal').on('keydown', function(event)
                      {
                          $(this).find('button[data-key|=' + event.which + ']').trigger('click');
                      });
                  });




