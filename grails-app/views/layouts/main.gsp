<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>

        <%-- TODO : delete 3 following lines when production --%>
        <META http-equiv="Cache-Control" content="no-cache">
        <META http-equiv="Pragma" content="no-cache">
        <META http-equiv="Expires" content="0">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'shield_blue.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'shield_blue.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'shield_blue.png')}">

        <r:require modules="bootstrap"/>

        <%--link rel="stylesheet" href="${resource(dir: 'css', file: 'normalize.css')}" type="text/css"--%>
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'application.css')}" type="text/css">
        <link href="${resource(dir: 'css', file: 'clicker.css')}" rel='stylesheet' type='text/css'>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'dd.css')}" type="text/css"/>

        <style type="text/css">
            #dragTool
            {
                cursor: move;
            }
            a.twitter-follow-button, a.twitter-share-button
            {
                display: none; /* not visible until twitter js script loaded */
            }
            a.text:link, a.text:visited, a.text:hover {
                color: white;
                text-decoration: none;
            }
            a.text-dark:link, a.text-dark:visited, a.text-dark:hover {
                color: black;
                text-decoration: none;
            }
            .dd .arrow
            {
                background: url('${resource(dir: 'images', file: 'dd_arrow.gif')}') no-repeat;
            }
            .dd .ddTitle
            {
                background:#e2e2e4 url('${resource(dir: 'images', file: 'title-bg.gif')}') repeat-x left top;
            }
        </style>

		<g:layoutHead/>
		<r:layoutResources />
        <ga:trackPageview />

        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.blockUI.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.dd.min.js')}"></script>

        <script type="text/javascript">
            var displayDevModeWarning = false;
            var blockUiInhibiter = 0;
        </script>

    </head>

    <body>

        <div class="header">
            <div class="container">
                <div class="row">
                    <div class="span12">
                        <div id="guardianLogo" role="banner" style="padding-top: 5px; padding-bottom: 8px;">
                            <div style="float: left;">
                                <a class="text" href="<g:createLink controller="link" action="list" absolute="true"/>">
                                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50" style="margin-top: -10px;"/>
                                    <span class="lg big" style="display: inline-block; padding-top: 16px;"></span>

                                    <%-- TODO : remove when no beta anymore --%>
                                    <sup style="color: #bd362f; font-size: larger; margin-left: 5px; font-size: large;">BÊTA</sup>

                                    <span class="lgDescription" style="margin-left: 40px; width: 183px; "><g:message code="lg.description.small"/></span>
                                </a>
                            </div>

                            <sec:ifLoggedIn>
                                <div style="float: right; text-align: right; margin-top: 5px;">

                                    <div>
                                        <span style="margin-right: 30px;">
                                            <sec:ifAllGranted roles="ROLE_ADMIN">
                                                <div class="btn-group" style="margin-right: 20px; ">
                                                    <button class="btn btn-danger dropdown-toggle" data-toggle="dropdown"><g:message code="menu.admin.label"/> <span class="caret"></span></button>
                                                    <ul class="dropdown-menu">
                                                        <li><g:link controller="userCrud"><g:message code="menu.admin.users.label"/></g:link></li>
                                                        <li><g:link controller="roleCrud"><g:message code="menu.admin.roles.label"/></g:link></li>
                                                        <li><g:link controller="linkCrud"><g:message code="menu.admin.links.label"/></g:link></li>
                                                    </ul>
                                                </div>
                                            </sec:ifAllGranted>

                                            <g:link controller="link" action="list" class="btn btn-primary text"><g:message code="links.mylinks.label"/></g:link>

                                            <g:link controller="link" action="recentsLinks" class="btn btn-primary text">derniers liens ajoutés</g:link>

                                            <!--div class="btn-group" style="margin-right: 20px; ">
                                                <button class="btn btn-primary dropdown-toggle" data-toggle="dropdown">Recherche <span class="caret"></span></button>
                                                <ul class="dropdown-menu">
                                                    <li><g:link controller="roleCrud">derniers liens ajoutés</g:link></li>
                                                    <li><g:link absolute="true" uri="/recent">personnes les plus actives</g:link></li>
                                                </ul>
                                            </div-->

                                            <button class="btn btn-inverse with-tooltip" id="tools" rel="tooltip" data-placement="bottom" data-original-title="${message(code:'menu.tools.label')}">
                                                <i class="icon-wrench icon-white"></i>
                                            </button>

                                            <button class="btn btn-inverse with-tooltip" id="about" rel="tooltip" data-placement="bottom" data-original-title="${message(code:'menu.about.label')}">
                                                <i class="icon-info-sign icon-white"></i>
                                            </button>
                                        </span>

                                        <span style="margin-right: 5px;">

                                            <a class="text twitter-account" data-twitter-name="<sec:username/>" target="_blank">
                                                <img class="twitter-account" data-twitter-name="<sec:username/>"/>
                                                <span>
                                                    <sec:username/>
                                                </span>
                                            </a>
                                        </span>
                                        <a id="configurationButton" class="with-tooltip" rel="tooltip" data-placement="bottom" data-original-title="${message(code:'configuration.button.tooltip')}">
                                            <span class="btn btn-inverse btn-mini">
                                                <img src="${resource(dir: 'images', file: 'configuration.png')}"/>
                                            </span>
                                        </a>
                                        <g:link controller='logout' action='index' class="with-tooltip" rel="tooltip" data-placement="bottom" data-original-title="${message(code:'disconnect.button.tooltip')}">
                                            <span class="btn btn-inverse btn-mini"><i class="icon-off icon-white"></i></span>
                                        </g:link>
                                    </div>
                                    <div style="float: right; text-align: right; margin-top: 15px;">

                                        <g:form controller="person" action="persons" style="display: inline;margin-bottom: 0px;" class="form-horizontal">
                                            <div class="control-group">
                                                <label class="control-label" for="searchUsernameInput"><g:message code="user.search.label"/></label>
                                                <div class="controls">
                                                    <input type="text" id="searchUsernameInput" name="username" data-provide="typeahead"/>

                                                    <button type="submit" class="btn btn-primary" onclick="setSubmitFilterButtonToNormalState()" id="searchPerson-input"
                                                            style="vertical-align: top;">
                                                        <i class="icon-search icon-white"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <script type="text/javascript">
                                                $(document).ready(function(event)
                                                {
                                                    $('#searchUsernameInput').typeahead({

                                                                                  source: function (query, process) {
                                                                                      blockUiInhibiter++;
                                                                                      return $.getJSON(
                                                                                              '<lg:secureLink controller="person" action="persons" absolute="true"/>',
                                                                                              {
                                                                                                  username: $('#searchUsernameInput').val(),
                                                                                                  format: "json"
                                                                                              },
                                                                                              function (data) {
                                                                                                  blockUiInhibiter--;
                                                                                                  if ( data )
                                                                                                  {
                                                                                                      var extractedNames = [];
                                                                                                      for(var i = 0; i < data.length; i++)
                                                                                                      {
                                                                                                          extractedNames.push(data[i].username);
                                                                                                      }
                                                                                                  }
                                                                                                  return process(extractedNames);
                                                                                              }).error(function() { blockUiInhibiter--; });
                                                                                  }
                                                                              });
                                                });
                                            </script>
                                        </g:form>
                                    </div>
                                </div>
                            </sec:ifLoggedIn>

                            <sec:ifLoggedIn>
                                <div style="float: left; height: 20px; padding-top: 3px;">
                                    <%-- twitter follow button --%>
                                    <a href="https://twitter.com/linkguardian" class="twitter-follow-button" data-show-count="false">Follow @linkguardian</a>
                                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

                                    <%-- twitter recommend --%>
                                    <a href="https://twitter.com/share" class="twitter-share-button" data-text="online bookmarks manager" data-via="linkguardian" data-related="linkguardian" data-hashtags="linkguardian">Tweet</a>
                                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
                                </div>
                            </sec:ifLoggedIn>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container wrapper">

            <g:if env="test">
                <div class="row" style="padding-top: 5px; padding-bottom: 5px;">
                    <strong span="12" style="color: red; font-size: x-large;">This is an application used to make test integration.<br/>
                        To use the real application, go to <a href="https://linkguardian-blackdog.rhcloud.com/" class="text btn btn-primary">Link Guardian</a>
                    </strong>
                </div>
            </g:if>

            <div class="row">
                <div class="span12">
                    <g:layoutBody/>
                    <g:javascript library="application"/>
                </div>
            </div>
        </div>
        <r:layoutResources />

        <footer>
            <div class="container wrapper">
                <div class="row">
                    <div class="span12 copyright" style="text-align: left;">
                        <g:message code="app.copyright"/>
                    </div>
                </div>
            </div>
        </footer>

        <div id="aboutDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="dialog.about.title"/></h3>
            </div>
            <div class="modal-body">

                <p class="text-info"><g:message code="lg.description.small"/></p>

                <g:include view="fragments/linkguardian_description.gsp"/>

            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true"><g:message code="close.button.label"/></button>
            </div>
        </div>

        <div id="toolsDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="dialog.tools.title"/></h3>
            </div>
            <div class="modal-body">
                <g:message code="dialogs.tools.paragraph"/>
                <p>
                    <img src="<g:resource dir="images" file="dragTool-final-reduced.png"/>"/>
                </p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true"><g:message code="close.button.label"/></button>
            </div>
        </div>
        <div id="configurationDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="dialog.configuration.title"/></h3>
            </div>
            <div class="modal-body" style="height: 150px;">
                <g:formRemote id="configurationForm" name="configurationForm" url="[controller: 'person', action: 'saveConfiguration']"
                              method="POST" onSuccess="configurationSaved(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                    <g:message code="links.forms.configuration.privacy.label"/><br/>
                    <select name="privacy" id="privacy" style="width: 300px; margin-left: 50px;" data-original-value="<lg:user_privacy/>">
                        <option value="ALL_LOCKED"><g:message code="links.forms.configuration.privacy.locked"/></option>
                        <option value="ALL_PUBLIC"><g:message code="links.forms.configuration.privacy.public"/></option>
                        <%--option value="LINK_PER_LINK"><g:message code="links.forms.configuration.privacy.linkPerLink"/></option--%>
                    </select>
                </g:formRemote>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true" onclick="javascript:$('#configurationForm').submit();"><g:message code="links.dialogs.result.save"/></button>
            </div>
        </div>
        <div id="devWarningDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> WARNING !!!!!!!!</h3>
            </div>
            <div class="modal-body">
                this application is in <strong>development mode</strong>.<br/>
                You can try it but all <strong>your data can be deleted at any time.</strong>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.yes"/></button>
            </div>
        </div>

        <script type="text/javascript">

            var configurationSaved = function(data)
            {
                // apply new values as original values
                var policy = $('#privacy');
                policy.attr('data-original-value', policy.msDropDown().data("dd").get('value'));

                // reload current page
                window.location.reload();
            };

            var openConfiguration = function()
            {
                $('#configurationButton').trigger('click');
            };

            var includeTwitterLogo = function()
            {
                $('img.twitter:not(.included)').attr('src', '<g:resource  dir="images" file="twitter.png"/>').addClass("included");
                $('img.twitter-white:not(.included)').attr('src', '<g:resource  dir="images" file="twitter-white.png"/>').addClass("included");
            };

            $(document).ready(
                    function()
                    {
                        if (displayDevModeWarning)
                        {
                            <g:if env="production">
                            $('#devWarningDialog').modal();
                            </g:if>
                        }

                        includeTwitterLogo();

                        try
                        {
                            $("body select").msDropDown();
                        }
                        catch(e)
                        {
                            alert(e.message);
                        }

                        $('.lg').html('<g:message code="lg.title"/>');

                        $('#about').on('click', function(event)
                        {
                            $('#aboutDialog').modal();
                        });

                        // complete the href of dragTool
                        var dragHref =
                                'javascript:(function(){' +
                                'var u="<g:createLink controller="link" action="addUrl" absolute="true"/>?render=html&url="+escape(document.location.href);' +
                                'var a=function(){' +
                                'if(!window.open(u))location.href=u;' +
                                '};' +
                                'if(/Firefox/.test(navigator.userAgent))' +
                                'setTimeout(a,0);' +
                                'else a();' +
                                '})();';

                        $('#dragTool').attr('href', dragHref);

                        $('#tools').on('click', function(event)
                        {
                            $('#toolsDialog').modal();
                        });

                        var hideBlockUi = function(event){
                            if ( blockUiInhibiter == 0 )
                            {
                                setTimeout(function(){
                                    $.unblockUI();
                                }, 200); //TODO : reduce additional times
                            }
                        };
                        $(document).ajaxStart(function(event){
                            if ( blockUiInhibiter == 0 )
                            {
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
                            }
                        })
                                .ajaxStop(hideBlockUi).ajaxError(hideBlockUi);

                        includeTwitterAccountLogo();

                        $('a.twitter-account:not(.included)').each(function(index, value)
                                                    {
                                                        var $value = $(value);
                                                        $value.attr('href', 'https://twitter.com/' + $value.attr('data-twitter-name'));
                                                        $value.addClass('included');
                                                    });

                        $('#configurationButton').on('click', function(event)
                        {
                            var select = $('#privacy');
                            var handler = select.msDropDown().data("dd");
                            handler.set('value', select.attr('data-original-value'));

                            $('#configurationDialog').modal();
                        });
                    });

        </script>

    </body>
</html>
