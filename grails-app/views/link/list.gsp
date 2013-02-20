<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Link Guardian</title>
        <r:require modules="mustache"/>

        <link rel="stylesheet" href="${resource(dir: 'css', file: 'jqcloud.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'links.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'dd.css')}" type="text/css"/>

        <style type="text/css">

            /* add here to test without deployment issue */
            .dd .arrow {
                width: 16px;
                height: 16px;
                margin-top: -8px;
                background: url(${resource(dir: 'images', file: 'dd_arrow.gif')}) no-repeat;
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
                            <legend>&nbsp;Search</legend>
                            &nbsp;
                            <select name="read_status" id="read_status" style="width: 188px;">
                                <option value="all" data-image="${resource(dir: 'images', file: 'world.png')}">all</option>
                                <option value="read" data-image="${resource(dir: 'images', file: 'checked.png')}">already read</option>
                                <option value="unread" data-image="${resource(dir: 'images', file: 'clock.png')}">not read yet</option>
                            </select>

                            <div class="input-append">
                                <g:textField id="filterInput" name="token" title="filter" placeholder="filter by tag" class="input-medium" maxlength="50"/>
                                <span class="add-on with-tooltip" id="clearFilterTag" rel="tooltip" data-placement="top" data-original-title="clear tag filter">
                                    <img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/>
                                </span>
                                <span class="add-on with-tooltip" id="showTagsCloud" rel="tooltip" data-placement="top" data-original-title="open tags cloud">
                                    <img src="${resource(dir: 'images', file: 'cloud.png')}" width="22px"/>
                                </span>
                            </div>

                            <button type="submit" class="btn btn-primary" onclick="setSubmitFilterButtonToNormalState()" id="filter-input">
                                <i class="icon-search icon-white"></i>
                            </button>

                            <div style="margin-top: 3px; margin-bottom: 3px;">
                                &nbsp;&nbsp;Sort by
                                <select name="sortBy" style="width: 180px;">
                                    <option value="creationDate" data-image="${resource(dir: 'images', file: 'date.png')}">creation date</option>
                                    <option value="note" data-image="${resource(dir: 'images', file: 'star.png')}">note</option>
                                </select>
                                <select name="sortType" style="width: 150px;">
                                    <option value="asc" data-image="${resource(dir: 'images', file: 'up.png')}">up</option>
                                    <option value="desc" data-image="${resource(dir: 'images', file: 'down.png')}">down</option>
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
                            <legend>Add a link</legend>

                            <div class="input-prepend input-append" style="margin-bottom: 3px;">
                                <span class="add-on">url</span>
                                <input type="text" id="txtUrl" name="url" class="input-xxlarge" placeholder="http://..." maxlength="200"/> <%-- required="" --%>

                                <button type="submit" class="btn btn-primary">
                                    <i class="icon-plus icon-white"></i>
                                </button>
                            </div>

                            <div>
                                <span class="label" style="vertical-align: top; margin-top: 6px;">Tags (Optional)</span> <%--a class="btn btn-info btn-mini" id="showTagInput">show</a--%>
                                <span>
                                    <g:textField id="txtTag" name="tag"
                                                 style="font-size: 13px; margin-bottom: 0px;"
                                                 class="input-xlarge with-tooltip" placeholder="for example : news economy ..." maxlength="100"
                                                 rel="tooltip" data-placement="top" data-original-title="space separated tag names"/>
                                </span>
                            </div>
                        </fieldset>

                    </g:formRemote>
                </div>

            </div>
        </div>

        <div id="messageContainer" class="message-box" style="height: 38px;">
            <div id="message"></div>
        </div>

        <div id="no-result" class="alert alert-info message-box">
            No result
        </div>
        <div id="listing-part"></div>

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
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
            </div>
            <div class="modal-body">
                <p>Do you really want to delete this link?</p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteLink();">Yes</button>
            </div>
        </div>
        <div id="deleteTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
            </div>
            <div class="modal-body">
                <p>Do you really want to delete this tag?</p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="deleteTag();">Yes</button>
            </div>
        </div>
        <div id="addTagDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Add tags</h3>
            </div>
            <div class="modal-body" style="text-align: center;">
                <g:textField id="newTagInput" name="name" class="input-xlarge"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="addTag();">Yes</button>
            </div>
        </div>
        <div id="markAsReadDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Mark as read?</h3>
            </div>
            <div class="modal-body">
                <p class="question"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();">Yes</button>
            </div>
        </div>
        <div id="tagsCloudDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue.png')}" alt="LinkGuardian" width="50"/> Cloud of tags</h3>
            </div>
            <div class="modal-body">
                <p class="question">Click on a tag to filter on it</p>
                <div id="tagsCloud" style="width: 520px; height: 310px;"/>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jqcloud-1.0.3.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.dd.min.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script>

    <g:javascript>
        $(document).ready(
                function()
                {
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
                    $('#filterLinkForm select').on('change', function(event)
                    {
                        setSubmitFilterButtonToClickState();
                    });
                });
    </g:javascript>

	</body>
</html>
