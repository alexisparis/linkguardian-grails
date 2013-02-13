<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Link Guardian</title>
        <r:require modules="bootstrap"/>
        <r:require modules="mustache"/>

        <style type="text/css">

    #navigation
    {
        cursor: pointer;
    }
    div.linkpart
    {
        width: 307px;
        float: left;
        margin-right: 10px;
        margin-bottom: 10px;
        background-color: #d2e1ff;
        border-radius: 5px 5px 5px;
        border: 1px solid #0081c2;
        padding: 2px;
        cursor: pointer;
    }
    div.linkpart.read
    {
        background-color: #ddd;
        border-radius: 5px 5px 5px;
        border: 1px solid #888;
    }
    div.linkpart.read:hover
    {
        /*box-shadow: #ccc 5px 5px 5px;*/
    }
    div.linkpart.selected:not(.read)
    {
        background-color: #accdf6;
        border: 1px solid #002a80;
    }
    div.linkpart.selected:hover:not(.read)
    {
        background-color: #accdf6;
        /*box-shadow: #b0c4de 5px 5px 5px;*/
    }
    div.linkpart:hover:not(.read)
    {
        background-color: #ccdbf9;
        /*box-shadow: #b0c4de 5px 5px 5px;*/
    }
    div.linkpart div.rateAndOperations
    {
        float: right;
    }
    div.linkpart .domain
    {
        color: #696969;
    }
    span.tag
    {
        border-radius: 5px 5px 5px;
        margin-right: 1px;
        margin-left: 1px;
        color: white;
        margin-bottom: 1px;
        padding-right: 1px;
        padding-left: 5px;
    }
    button.close
    {
        margin-left: 10px;
        margin-right: 5px;
    }
    div.linkpart:not(hover) img.raty-cancel,
    div.linkpart:not(hover) .visible-on-hover
    {
        visibility: hidden;
    }
    div.linkpart:hover img.raty-cancel,
    div.linkpart:hover .visible-on-hover
    {
        visibility: visible;
    }
    button.deleteTagButton
    {
        margin-left: 1px;
        margin-right: 1px;
        margin-top: -3px;
        opacity: 0.6;
    }
    div.linkpart:not(hover) .displayed-on-hover
    {
        display: none;
    }
    div.linkpart:hover .displayed-on-hover
    {
        display: inline-block;
    }
    div.tags /* used to isplay tags with a scroll if a tag name is too long */
    {
        overflow:auto;
    }
    span.tag:not(hover) button.deleteTagButton
    {
        visibility: hidden;
    }
    span.tag:hover button.deleteTagButton
    {
        visibility: visible;
    }
    div.linkpart[data-note=Note_0] span.rate
    {
        visibility: hidden;
    }
    div.linkpart:hover span.rate
    {
        visibility: visible;
    }
    div.linkpart.read .read
    {
        display: none;
    }
    div.linkpart:not(.read) .unread
    {
        display: none;
    }
    div.actions .icon
    {
        opacity: 0.3;
    }
    div.actions:hover .icon
    {
        opacity: 0.7;
    }
        </style>
	</head>
	<body>

        <p>
            <openid:identifier />
        </p>
        <p>

        <ul class="nav nav-pills" id="navigation">
            <li>
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

                <g:formRemote id="filterLinkForm" class="form-inline" name="addUrlForm" url="[controller: 'link', action: 'filter']"
                              method="POST" style="display: inline;"
                              onSuccess="updateLinks(data)" onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)"> <!-- update="[success: 'message', failure: 'error']"  -->
                    <fieldset>
                        <!--g:hiddenField name="archived" id="archived-input"/-->
                        <label class="checkbox read-check" style="margin-right: 10px;">
                            <input class="read-marker" type="checkbox" name="read" id="read" value="read"/>
                                <i class="icon-eye-open"></i>&nbsp;read
                        </label>
                        <label class="checkbox read-check" style="margin-right: 10px;">
                            <input class="read-marker" type="checkbox" name="unread" id="unread" value="unread" checked>
                            <i class="icon-eye-close"></i>&nbsp;unread
                        </label>
                        <!--select name="sort">
                            <option value="date">sort by date</option>
                            <option value="rate">sort by rate</option>
                        </select-->

                        <div class="input-append">
                            <g:textField id="filterInput" name="token" title="filter" placeholder="filter by tag" class="input-medium" maxlength="50"/>
                            <span class="add-on" id="clearFilterTag"><img src="${resource(dir: 'images', file: 'delete.png')}" width="14"/></span>
                        </div>

                        <g:submitButton onclick="setSubmitFilterButtonToNormalState();" id="filter-input" name="Filter" class="btn btn-primary" style="background-image_old: url('${resource(dir: 'images', file: 'search.png')}')"/>
                    </fieldset>
                </g:formRemote>
            </li>
            <li style="float: right;">
                <button class="btn" id="about">About</button>
            </li>
        </ul>

        <%--
           cannot use <g:javascript src="jquery.raty.js" /> since it does not work with https
        --%>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.raty.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.masonry.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.blockUI.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js', file: 'links.js')}"></script>

        <g:javascript>
            $(document).ready(function()
                              {
                                  $(document).ajaxStart(function(){
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
                                  })
                                      .ajaxStop(function(){
                                                    setTimeout(function(){
                                                        $.unblockUI();
                                                    }, 200); //TODO : reduce additional times
                                                });

                                  $.fn.raty.defaults.path = '${resource(dir: 'images')}';
                              });
        </g:javascript>

        <div id="add-part">
            <g:formRemote name="addUrlForm" url="[controller: 'link', action: 'addUrl']"
                          method="POST" onSuccess="resetAddForm();submitFilterForm(); displayMessage(data);"
                          onFailure="displayFailure(XMLHttpRequest,textStatus,errorThrown)">

                <div class="input-prepend input-append">
                    <span class="add-on">url</span>
                    <input type="url" id="txtUrl" name="url" class="input-xxlarge" placeholder="http://..." required="" maxlength="200"/>

                    <input class="btn btn-primary" type="submit" value="Add link"/>

                </div>

                <div>
                    <span class="label">Tags (Optional)</span> <a class="btn btn-info btn-mini" id="showTagInput">show</a><br/>
                    <div style="height: 20px; margin-top: 2px;">
                        <g:textField id="txtTag" name="tag" class="input-xxlarge" placeholder="Comma separated tag names e.g. news, technical, travel, leisure" maxlength="100"/>
                    </div>
                </div>

            </g:formRemote>
        </div>

        <div id="messageContainer" style="height: 38px; margin-top: 3px; margin-bottom: 3px;">
            <div id="message" ></div>
        </div>

        <div id="listing-part"></div>

        </div>

        <!-- dialogs -->
        <div id="deleteLinkDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3>
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Confirmation</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Add a new tag</h3>
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
                    <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> Mark as read?</h3>
            </div>
            <div class="modal-body">
                <p class="question"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">No</button>
                <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true" onclick="markSelectedLinkAsRead();">Yes</button>
            </div>
        </div>
    <div id="aboutDialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>
                <img src="${resource(dir: 'images', file: 'shield_blue3.png')}" alt="LinkGuardian" width="50"/> About Link Guardian</h3>
        </div>
        <div class="modal-body">
            <p>Link Guardian is a tool that allow to <span class="label label-success">register websites adress</span>.</p>
            <p>It is especially designed to manage articles that you want to <span class="label label-success">read later</span> or if you want to collect a set of articles related to the same subject.</p>
            <p>Each link registered can be <u>tagged</u>, <u>marked as read or unread</u> or <u>removed</u> if the content of an article is not interesting enough.</p>
            <p style="margin-top: 30px;"><strong>Link Guardian allows you to <span class="label label-success">bookmark websites</span> that you like and helps you <span class="label label-success">never forget to read an attractive article</span>.</strong></p>

        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" data-key="13" data-dismiss="modal" aria-hidden="true">Close</button>
        </div>
    </div>

	</body>
</html>
