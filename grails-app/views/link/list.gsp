<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title><g:message code="links.title"/></title>
        <r:require modules="mustache"/>

        <link rel="stylesheet" href="${resource(dir: 'css', file: 'jqcloud.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'links.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'dd.css')}" type="text/css"/>

        <style type="text/css">
            /*#infscr-loading
            {
                margin-right: auto;
                margin-left: auto;
                text-align: center;
            }
            #infscr-loading > img
            {
                margin-right: auto;
                margin-left: auto;
            }*/
            .dd .arrow
            {
                background: url('${resource(dir: 'images', file: 'dd_arrow.gif')}') no-repeat;
            }
            .dd .ddTitle
            {
                background:#e2e2e4 url('${resource(dir: 'images', file: 'title-bg.gif')}') repeat-x left top;
            }
        </style>

	</head>
	<body>

        <div class="container forms">
            <div class="row">
                <div class="span5">

                    <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                                  method="POST" style="display: inline;"
                                  onSuccess="updateLinks(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">
                        <fieldset>
                            <legend>&nbsp;<g:message code="links.forms.search.title"/></legend>
                            &nbsp;
                            <select name="read_status" id="read_status" style="width: 188px;">
                                <option value="all" data-image="${resource(dir: 'images', file: 'world.png')}"><g:message code="links.forms.search.read_status.all"/></option>
                                <option value="read" data-image="${resource(dir: 'images', file: 'checked.png')}"><g:message code="links.forms.search.read_status.read"/></option>
                                <option value="unread" data-image="${resource(dir: 'images', file: 'clock.png')}"><g:message code="links.forms.search.read_status.unread"/></option>
                            </select>

                            <div class="input-append" id="filterByTgContainer">
                                <input type="text" id="filterInput" name="token" title="filter" placeholder='<g:message code="links.forms.search.filterInput.placeholder"/>' class="input-medium" maxlength="50"/>
                                <span class="add-on with-tooltip" id="clearFilterTag" rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.search.clearFilterTag.tooltip"/>">
                                    <img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/>
                                </span>
                                <span class="add-on with-tooltip" id="showTagsCloud" rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.search.showTagsCloud.tooltip"/>">
                                    <img src="${resource(dir: 'images', file: 'cloud.png')}" width="22px"/>
                                </span>
                            </div>

                            <button type="submit" class="btn btn-primary" onclick="setSubmitFilterButtonToNormalState()" id="filter-input">
                                <i class="icon-search icon-white"></i>
                            </button>

                            <div style="margin-top: 3px; margin-bottom: 3px;">
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

                        </fieldset>
                    </g:formRemote>
                </div>

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
                                <input type="text" id="txtUrl" name="url" class="input-xxlarge" placeholder="<g:message code="links.forms.add.txtUrl.placeholder"/>" maxlength="200"/> <%-- required="" --%>

                                <button type="submit" class="btn btn-primary">
                                    <i class="icon-plus icon-white"></i>
                                </button>
                            </div>

                            <div>
                                <span class="label" style="vertical-align: top; margin-top: 6px;"><g:message code="links.forms.add.tags.title"/></span> <%--a class="btn btn-info btn-mini" id="showTagInput">show</a--%>
                                <span>
                                    <input type="text"
                                           id="txtTag" name="tag"
                                           style="font-size: 13px; margin-bottom: 0px;"
                                           class="input-xlarge with-tooltip" placeholder="<g:message code="links.forms.add.txtTag.placeholder"/>" maxlength="100"
                                           rel="tooltip" data-placement="top" data-original-title="<g:message code="links.forms.add.txtTag.tooltip"/>"/>
                                </span>
                            </div>
                        </fieldset>

                    </g:formRemote>
                </div>

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
            <div class="modal-body" style="text-align: center;">
                <g:textField id="newTagInput" name="name" class="input-xlarge"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.no"/></button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="addTag();"><g:message code="links.dialogs.result.yes"/></button>
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
        <div id="tagsCloudDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> <g:message code="links.dialogs.tagsCloudDialog.title"/></h3>
            </div>
            <div class="modal-body">
                <p class="question"><g:message code="links.dialogs.tagsCloudDialog.label"/></p>
                <div id="tagsCloud" style="width: 520px; height: 310px;"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true"><g:message code="links.dialogs.result.cancel"/></button>
            </div>
        </div>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jqcloud-1.0.3.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.dd.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.infinitescroll.min.js')}"></script>

        <g:javascript>
            var infiniteScrollLoadImage = '${resource(dir: "images/loading", file: "loading_medium.gif")}';
            var noTagsFoundError  = '<g:message code="links.cloudtags.noTagsFoundError.label"/>';
            var defaultErrorMessage = '<g:message code="links.default.errorMessage.label"/>';
            var markAsReadMessage = '<g:message code="links.dialogs.markAsReadDialog.label"/>';
            var markAsReadFromMessage = '<g:message code="links.dialogs.markAsReadDialog.from.label"/>';
            var infinitescrollFinishedMsg = '<g:message code="infinitescroll.finishedMsg"/>';
            var infinitescrollMsgText = '<g:message code="infinitescroll.msgText"/>';
            var templateI18n = {
                goto : '<g:message code="links.link.template.domain.goto"/>',
                addTag : '<g:message code="links.link.template.domain.addTag"/>',
                deleteLink : '<g:message code="links.link.template.domain.deleteLink"/>',
                markAsRead : '<g:message code="links.link.template.domain.markAsRead"/>',
                markAsUnread : '<g:message code="links.link.template.domain.markAsUnread"/>',
                deleteTag : '<g:message code="links.link.template.domain.deleteTag"/>',
                filterOnTag : '<g:message code="links.link.template.domain.filterOnTag"/>'
            };
            //var  = '<g:message code=""/>';
        </g:javascript>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script>

    <g:javascript>
        $(document).ready(
                function()
                {
                    displayDevModeWarning = true;

                    $.fn.raty.defaults.path = '${resource(dir: 'images')}';

                    try
                    {
                        $("body select").msDropDown();
                    }
                    catch(e)
                    {
                        alert(e.message);
                    }

                    // add here to test without deployment issue

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
                });
    </g:javascript>

	</body>
</html>
