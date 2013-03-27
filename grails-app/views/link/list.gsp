<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title><g:message code="links.title"/></title>
        <r:require modules="mustache"/>
        <r:require module="modernizr"/>

        <link rel="stylesheet" href="${resource(dir: 'css', file: 'jqcloud.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'links.css')}" type="text/css">

        <style type="text/css">
            <g:if test="${isOwner}">
                .action-toolbar .importLinkButton
                {
                    display: none;
                }
            </g:if>
            <g:else>
                .action-toolbar.desktop .read, .action-toolbar .unread, .action-toolbar .deleteLinkButton, .deleteTagButton
                {
                    display: none;
                }
                span.tag
                {
                    padding-right: 5px;
                }
            </g:else>
        </style>

	</head>
	<body>

        <script type="text/javascript">
            if (Modernizr.touch){
            //if ( true ){
                // import links_touch.css
                console.log("import links_touch.css");
                $('body').append('<link rel="stylesheet" href="${resource(dir: 'css', file: 'links_touch.css')}" type="text/css">');
            }
        </script>

        <div class="container forms">
            <div class="row">

                <g:if test="${!isOwner}">
                    <g:if test="${isGlobal}">
                        <div class="span2">
                            <legend>&nbsp;<g:message code="links.recent.label"/></legend>
                            <img style="margin-left: 10px; margin-bottom: 5px;" width="60px" src="${resource(dir: 'images', file: 'world2.png')}"/>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="span3" style="overflow: hidden;">
                            <legend>&nbsp;<g:message code="links.linksOf.label"/></legend>

                            &nbsp;<a class="text twitter-account" data-twitter-name="${linksOfUser}" target="_blank" style="margin-left: 20px;">
                            <img class="twitter-account" width="60px" data-twitter-icon-size="bigger" data-twitter-name="${linksOfUser}"/>
                            <span style="color: black; vertical-align: middle; font-size: x-large;">
                                ${linksOfUser}
                            </span>
                        </a>
                        </div>
                    </g:else>
                </g:if>

                <div class="<g:if test='${isOwner}'>span5</g:if>
                    <g:else>
                        <g:if test="${isGlobal}">span10</g:if>
                        <g:else>span9</g:else>
                    </g:else>">

                    <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                                  method="POST" style="display: inline;"
                                  onSuccess="updateLinks(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                        <fieldset>
                            <legend>&nbsp;
                            <g:if test="${isOwner}">
                                <g:message code="links.forms.search.title"/>

                                <a id="shareLinksButton" style="float: right; margin-top: 5px; margin-right: 0px;" class="text btn btn-small btn-primary">
                                    <g:message code="links.share.button.label"/>
                                </a>
                            </g:if>
                            <g:else>
                                <g:if test="${isGlobal}">
                                    <g:message code="links.forms.search.recent.title"/>
                                </g:if>
                                <g:else>
                                    <g:message code="links.forms.search.others.title" args="${[linksOfUser]}"/>
                                </g:else>

                                <a style="float: right; margin-top: 5px; margin-right: 5px;" class="text btn btn-primary" href="<g:createLink controller="link" action="list" absolute="true"/>">
                                    <i class="icon icon-circle-arrow-left icon-white"></i>&nbsp;<g:message code="links.returnToMyLinks.button.label"/>
                                </a>
                            </g:else>
                            </legend>
                            &nbsp;
                            <select name="read_status" id="read_status" style="width: 188px; <g:if test='${!isOwner}'>display: none; </g:if>">
                                <option value="all" data-image="${resource(dir: 'images', file: 'world.png')}"><g:message code="links.forms.search.read_status.all"/></option>
                                <option value="read" data-image="${resource(dir: 'images', file: 'checked.png')}"><g:message code="links.forms.search.read_status.read"/></option>
                                <option value="unread" data-image="${resource(dir: 'images', file: 'clock.png')}"><g:message code="links.forms.search.read_status.unread"/></option>
                            </select>

                            <div class="input-append" id="filterByTgContainer">
                                <input class="input-medium" type="text" value="${tag}" id="filterInput" name="token" title="filter" placeholder='<g:message code="links.forms.search.filterInput.placeholder"/>' maxlength="50"/>
                                <span class="btn button add-on with-tooltip" id="clearFilterTag" rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.search.clearFilterTag.tooltip"/>">
                                    <%--img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/--%>
                                    &times;
                                </span>
                                <span class="btn button add-on with-tooltip" id="showTagsCloud" rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.search.showTagsCloud.tooltip"/>">
                                    <img src="${resource(dir: 'images', file: 'cloud.png')}" width="22px"/>
                                </span>
                            </div>

                            <button type="submit" class="btn btn-primary" onclick="setSubmitFilterButtonToNormalState()" id="filter-input">
                                <i class="icon-search icon-white"></i>
                            </button>

                            <div style="margin-top: 3px; margin-bottom: 3px;<g:if test="${isGlobal}">display: none;</g:if>">
                                &nbsp;&nbsp;<g:message code="links.forms.search.sortBy.title"/>
                                <select name="sortBy" id="sortBy" style="width: 180px;">
                                    <option value="creationDate" data-image="${resource(dir: 'images', file: 'date.png')}"><g:message code="links.forms.search.sortBy.creationDate"/></option>
                                    <option value="note" data-image="${resource(dir: 'images', file: 'star.png')}"><g:message code="links.forms.search.sortBy.note"/></option>
                                </select>
                                <select name="sortType" id="sortType" style="width: 150px;">
                                    <option value="asc" data-image="${resource(dir: 'images', file: 'up.png')}"><g:message code="links.forms.search.sortType.asc"/></option>
                                    <option value="desc" selected="selected" data-image="${resource(dir: 'images', file: 'down.png')}"><g:message code="links.forms.search.sortType.desc"/></option>
                                </select>
                            </div>
                            <g:hiddenField id="linksofuser" name="linksofuser" value="${linksOfUser}"/>
                            <g:hiddenField id="allLinksPrivate" name="allLinksPrivate" value="${allLinksPrivate}"/>
                            <g:hiddenField id="searchType" name="searchType" value="${searchType}"/>

                        </fieldset>
                    </g:formRemote>
                </div>

                <g:if test="${isOwner}">
                    <div class="span7">
                        <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                                      method="POST" onSuccess="resetAddForm();submitFilterForm(); displayMessage(data);"
                                      onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)"
                                      style="margin-bottom: 3px;">
                            <fieldset>
                                <legend><g:message code="links.forms.add.title"/></legend>
                                <g:hiddenField name="render" value="json"></g:hiddenField>

                                <div class="input-prepend input-append" style="margin-bottom: 3px;">
                                    <span class="add-on"><g:message code="links.forms.add.url.title"/></span>
                                    <input type="text" id="txtUrl" name="url" style="width: 70%;" placeholder="<g:message code="links.forms.add.txtUrl.placeholder"/>" maxlength="200"/> <%-- required="" --%>

                                    <button type="submit" class="btn btn-primary">
                                        <i class="icon-plus icon-white"></i>
                                    </button>
                                </div>

                                <div>
                                    <span class="label" style="vertical-align: top; margin-top: 6px;"><g:message code="links.forms.add.tags.title"/></span> <%--a class="btn btn-info btn-mini" id="showTagInput">show</a--%>
                                    <span>
                                        <input type="text"
                                               id="txtTag" name="tag"
                                               style="font-size: 13px; margin-bottom: 0px; width: 30%;"
                                               class="with-tooltip" placeholder="<g:message code="links.forms.add.txtTag.placeholder"/>" maxlength="100"
                                               rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.add.txtTag.tooltip"/>"/>
                                    </span>
                                </div>
                            </fieldset>

                        </g:formRemote>
                    </div>
                </g:if>

            </div>
        </div>

        <div id="messageContainer" class="message-box" style="height: 38px; overflow: hidden;">
            <div id="message"></div>
        </div>

        <div id="no-result" class="alert alert-info message-box" style="display: none;">
            <g:message code="links.noresult.label"/>
        </div>

        <%--
            problem with masonry when no elements are in the listing-part when masonry initialization
            so --> factice item added to fix it
        --%>
        <div id="listing-part">
            <div class="linkpart" style="display: none;"></div>
        </div>

        <div id="nav-inf-scroll" style="display: none;">
            <a data-filter-url-model="<g:createLink controller="link" action="filter"/>">infinite-scroll link</a>
        </div>

        <div id="inf-scroll-load" style="margin-left: auto; margin-right: auto;">

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
        <g:formRemote id="showTagsCloudForm" name="showTagsCloudForm" url="[controller: 'link', action: 'getTagsCloud']"
                      method="POST" style="display: none;" onSuccess="showTagsCloud(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
            <g:hiddenField name="username" value="${linksOfUser}"/>
        </g:formRemote>

        <!-- form used to import a link -->
        <g:formRemote id="importLink" name="importLink" url="[controller: 'link', action: 'importLink']"
                      method="POST" style="display: none;" onSuccess="importDone(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
            <g:hiddenField name="id"/>
        </g:formRemote>

        <!-- ################# -->
        <!-- bootstrap dialogs -->
        <!-- ################# -->

        <div id="deleteLinkDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.confirmation.title"/></h3>
            </div>
            <div class="modal-body">
                <p><g:message code="links.dialogs.deleteLinkDialog.label"/></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.no"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteLink();"><g:message code="links.dialogs.result.yes"/></button>
            </div>
        </div>
        <div id="deleteTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.confirmation.title"/></h3>
            </div>
            <div class="modal-body">
                <p><g:message code="links.dialogs.deleteTagDialog.label"/></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.no"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteTag();"><g:message code="links.dialogs.result.yes"/></button>
            </div>
        </div>
        <div id="addTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.addTagDialog.title"/></h3>
            </div>
            <%--  add overflow visible to allow to display the typeahead combo correctly --%>
            <div class="modal-body" style="text-align: center; overflow-y: visible;">
                <g:textField id="newTagInput" name="name" class="input-xlarge"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.cancel"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="addTag();"><g:message code="links.dialogs.result.save"/></button>
            </div>
        </div>
        <div id="markAsReadDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.markAsReadDialog.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.no"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();"><g:message code="links.dialogs.result.yes"/></button>
            </div>
        </div>
        <div id="markAsReadOrDeleteDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.markAsReadOrDeleteDialog.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question">
                    <g:message code="links.dialog.markAsReadOrDeleteDialog.paragraph"/>
                </p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.markAsReadOrDeleteDialog.result.conserve"/></button>
                <button class="btn" data-dismiss="modal" aria-hidden="true" onclick="clickOnDeleteOfSelectedLink();"><g:message code="links.dialogs.markAsReadOrDeleteDialog.result.delete"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();"><g:message code="links.dialogs.markAsReadOrDeleteDialog.result.markAsRead"/></button>
            </div>
        </div>
        <div id="tagsCloudDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.tagsCloudDialog.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question"><g:message code="links.dialogs.tagsCloudDialog.label"/></p>
                <div id="tagsCloud" style="width: 520px; height: 310px;"></div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.cancel"/></button>
            </div>
        </div>
        <div id="shareWarningDueToPrivacyDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.shareWarningDueToPrivacy.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question"><g:message code="links.dialogs.shareWarningDueToPrivacy.paragraph"/></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.no"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="openConfiguration();"><g:message code="links.dialogs.result.yes"/></button>
            </div>
        </div>
        <div id="shareImpossibleCauseNoLinksDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.shareImpossibleCauseNoLinks.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question"><g:message code="links.dialogs.shareImpossibleCauseNoLinks.paragraph"/></p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.ok"/></button>
            </div>
        </div>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jqcloud-1.0.3.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.infinitescroll.min.js')}"></script>

        <g:javascript>

            var showUserInLink = ${isGlobal};
            var showReadUnreadLink = ${!isGlobal && isOwner};
            var searchType = '${searchType}';

            var infiniteScrollLoadImage = '${resource(dir: "images/loading", file: "loading_medium.gif")}';
            var rootUrl = '<g:createLink uri="/" absolute="true"/>';
            var noTagsFoundError  = '<g:message code="links.cloudtags.noTagsFoundError.label"/>';
            var modifyLinkFromMessage = '<g:message code="links.dialogs.markAsReadOrDeleteDialog.from.label"/>';
            var infinitescrollFinishedMsg = '<g:message code="infinitescroll.links.finishedMsg"/>';
            var infinitescrollMsgText = '<g:message code="infinitescroll.links.msgText"/>';
            var templateI18n = {
                goto : '<g:message code="links.link.template.domain.goto"/>',
                addTag : '<g:message code="links.link.template.domain.addTag"/>',
                deleteLink : '<g:message code="links.link.template.domain.deleteLink"/>',
                tweetLink :'<g:message code="links.link.template.domain.tweetLink"/>',
                markAsRead : '<g:message code="links.link.template.domain.markAsRead"/>',
                markAsUnread : '<g:message code="links.link.template.domain.markAsUnread"/>',
                deleteTag : '<g:message code="links.link.template.domain.deleteTag"/>',
                filterOnTag : '<g:message code="links.link.template.domain.filterOnTag"/>',
                importLink : '<g:message code="links.link.template.domain.importLink"/>',
                by : '<g:message code="links.link.template.domain.byUser"/>',
                byTooltip : '<g:message code="links.link.template.domain.byUserTooltip"/>'
            };
        </g:javascript>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script>

        <g:javascript>

            function shortenUrl(url, callback, _async)
            {
                _async = _async && typeof _async === 'boolean';

                jQuery.ajax('<g:createLink controller="link" action="shortenUrl" absolute="true"/>?url=' +url,
                    {
                        async:_async,
                        success: function(data, textStatus, jqXHR)
                        {
                            if ( data )
                            {
                                callback.call(this, data);
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown )
                        {
                            displayStdError();
                        }
                    })
            };

            function elPos(element){
                var position = { x:element.offsetLeft, y:element.offsetTop };
                while(element = element.offsetParent){
                    position.x += element.offsetLeft;
                    position.y += element.offsetTop;
                };
                return position;
            };

            $(document).ready(
                    function()
                    {
                        displayDevModeWarning = true;

                        $.fn.raty.defaults.path = '${resource(dir: 'images')}';

                        var $container = $('#listing-part');
                        $container.imagesLoaded(function(){

                            $container.masonry({
                                                   itemSelector : '#listing-part .linkpart',
                                                   isAnimated: false,
                                                   animationOptions: {
                                                      duration: 750,
                                                      easing: 'swing',
                                                      queue: false
                                                   }
                                               });

                            submitFilterForm();
                        });

                        $('#filterInput').typeahead({
                                                      source: function (query, process) {
                                                          blockUiInhibiter++;
                                                          return $.getJSON(
                                                                  <g:if env="development">
                                                                      '<g:createLink controller="link" action="tags" absolute="true"/>'
                                                                  </g:if>
                                                                  <g:else>
                                                                      '<lg:secureLink controller="link" action="tags" absolute="true"/>'
                                                                  </g:else>,
                                                                  {
                                                                      value: $('#filterInput').val()
                                                                  },
                                                                  function (data) {
                                                                      blockUiInhibiter--;
                                                                      return process(data);
                                                                  }).error(function() { blockUiInhibiter--; });
                                                      },
                                                      matcher: function(item) {
                                                         // to force typehead not to ignore items returned by the source method
                                                         return true;
                                                      }
                                                  });

                        var fixPersonTypeaheadPos = function(){
                            var box = $("#txtTag")[0];
                            var newPos = elPos(box);

                            $(box).parent().find("ul.typeahead").css({top: newPos.y+32, left: newPos.x});
                        };

                        $('#txtTag').typeahead({
                                                      source: function (query, process) {
                                                          blockUiInhibiter++;
                                                          return $.getJSON(
                                                                    <g:if env="development">
                                                                        '<g:createLink controller="link" action="tags" absolute="true"/>'
                                                                    </g:if>
                                                                    <g:else>
                                                                        '<lg:secureLink controller="link" action="tags" absolute="true"/>'
                                                                    </g:else>,
                                                                  {
                                                                      value: $('#txtTag').val()
                                                                  },
                                                                  function (data) {
                                                                      blockUiInhibiter--;
                                                                      return process(data);
                                                                  }).error(function() { blockUiInhibiter--; });
                                                      },
                                                      matcher: function(item) {
                                                         //fixPersonTypeaheadPos();
                                                         // to force typehead not to ignore items returned by the source method
                                                         return true;
                                                      }
                                                  });


                        $('#newTagInput').typeahead({
                                                      source: function (query, process) {
                                                          blockUiInhibiter++;
                                                          return $.getJSON(
                                                                    <g:if env="development">
                                                                        '<g:createLink controller="link" action="tags" absolute="true"/>'
                                                                    </g:if>
                                                                    <g:else>
                                                                        '<lg:secureLink controller="link" action="tags" absolute="true"/>'
                                                                    </g:else>,
                                                                  {
                                                                      value: $('#newTagInput').val()
                                                                  },
                                                                  function (data) {
                                                                      blockUiInhibiter--;
                                                                      return process(data);
                                                                  }).error(function() { blockUiInhibiter--; });
                                                      },
                                                      matcher: function(item) {
                                                         // to force typehead not to ignore items returned by the source method
                                                         return true;
                                                      }
                                                  });

                    });
        </g:javascript>

	</body>
</html>
