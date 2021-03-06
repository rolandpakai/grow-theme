<script type="text/javascript">
	$(function () {
		$('[data-toggle="tooltip"]').tooltip()
	});
	$(document).ready(function () {
		$(".wiki-actions .rating-thumb-up").addClass("btn btn-default btn-block");
		$(".wiki-actions .rating-thumb-down").addClass("btn btn-default btn-block");
	});
</script>
<#assign WikiHelperService = serviceLocator.findService("com.liferay.grow.wiki.helper.service.WikiHelperService")>
<#assign JSONFactoryUtil = serviceLocator.findService("com.liferay.portal.kernel.json.JSONFactoryUtil")>

<#assign data = WikiHelperService.getWikiPageContributors(entry.getNodeId(), entry.getTitle())>

<#assign contributors = JSONFactoryUtil.looseDeserialize(data.contributors)>

<#assign TaskHandler = serviceLocator.findService("com.liferay.micro.maintainance.api.TaskHandler")>

<#assign parentPage = WikiHelperService.getParentWikiPage(entry.getNodeId(), entry.getTitle())>

<#assign childPages = WikiHelperService.getChildWikiPages(entry.getNodeId(), entry.getTitle())>

<#assign linkedPages = WikiHelperService.getLinkedPages(entry.getNodeId(), entry.getTitle())>

<#assign childPagesList = JSONFactoryUtil.looseDeserialize(childPages.childPages)>

<#assign availableTasks = TaskHandler.getAvailableFlags(entry.getPageId())>

<#assign wikiPageClassName = "com.liferay.wiki.model.WikiPage" >
<#assign wikiNodeClassName = "com.liferay.wiki.model.WikiNode" >
<#assign serviceContext = staticUtil["com.liferay.portal.kernel.service.ServiceContextThreadLocal"].getServiceContext()>
<#assign httpServletRequest = serviceContext.getRequest()>
<#assign pubFriendlyURL = prefsPropsUtil.getString(companyId, "layout.friendly.url.public.servlet.mapping")>
<#assign privateFriendlyURL = prefsPropsUtil.getString(companyId, "layout.friendly.url.private.group.servlet.mapping")>
<#assign UserLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.UserLocalService")>
<#assign AssetTagLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetTagLocalService")>
<#assign AssetCategoryLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")>
<#assign SubscriptionLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.SubscriptionLocalService")>
<#assign isSubscribedPage = SubscriptionLocalService.isSubscribed(entry.getCompanyId(), themeDisplay.getUserId(), wikiPageClassName, entry.getResourcePrimKey())>
<#assign isSubscribedWiki = SubscriptionLocalService.isSubscribed(entry.getCompanyId(), themeDisplay.getUserId(), wikiNodeClassName, entry.getNodeId())>
<#assign tags = AssetTagLocalService.getAssetEntryAssetTags(assetEntry.getEntryId())>
<#assign categories = AssetCategoryLocalService.getAssetEntryAssetCategories(assetEntry.getEntryId())>
<#assign creatorUser = UserLocalService.getUser(assetEntry.getUserId())>
<#assign modifierUser = UserLocalService.getUser(entry.getStatusByUserId())>
<#assign renderURL = renderResponse.createRenderURL()>
<#assign assetRenderer = assetEntry.getAssetRenderer() />
<#assign portalURL = portal.getPortalURL(httpServletRequest)>
<#assign siteFriendlyURL = themeDisplay.getSiteGroup().getFriendlyURL()>
<#assign pageFriendlyURL = themeDisplay.getLayout().getFriendlyURL()>
<#if entry.getParentPage()?has_content>
	<#assign parentTitle = entry.getParentPage().getTitle()>
</#if>
	<div class="row wiki-body">
		<div class="col-md-8 wiki-content">
			<div class="wiki-actions">
				<ul class="list-unstyled">
					<li><@displayEditLink/></li>
					<li><@displayFriendlyURL name=entry.getTitle() /></li>
					<li><@displayAddChildLink/></li>
					<li><@displayPageSubscription/></li>
					<li><@displayPageDetails/></li>
					<li><@displayTaskFlagging/></li>
					<@getRatings/>
				</ul>
			</div>
			<#if tags?has_content>
				<#list tags as tag>
			    	<#if tag.name?matches("official", "i")>
			    		<#assign official="true">
			    	</#if>
				</#list>
			</#if>
			<h1 class="text-default">
				<#if official?has_content>
					<span class="">
						<i class="icon-check"></i>
						<span class="taglib-text hide-accessible"></span>
					</span>
				</#if>
				${entry.getTitle()}
			</h1>
			${formattedContent}
		</div>
		<div class="col-md-4 asideInfo">
			<div class="sidebar-box">
				<div class="mb40">
					<ul class="list-inline">
						<li><span class="glyphicon glyphicon-user"></span> updated by <a href="${portal.getPortalURL(httpServletRequest) + pubFriendlyURL + "/" + modifierUser.getScreenName()}">${modifierUser.getFullName()}</a></li>
						<li><span class="glyphicon glyphicon-calendar"> </span> ${assetEntry.getModifiedDate()?date}</li>
						<li><span class="glyphicon glyphicon-eye-open"></span> ${assetEntry.getViewCount()}</li>
					</ul>
					<ul class="list-inline">
						<li><span class="glyphicon glyphicon-user"></span> author: <a href="${portal.getPortalURL(httpServletRequest) + pubFriendlyURL + "/" + creatorUser.getScreenName()}">${creatorUser.getFullName()}</a></li>		
					</ul>				
				</div>

				<#if contributors?size != 0>
				<div class="mb40">
					<h4 class="sidebar-title">Contributors</h4>
					<ul class="list-unstyled">
						<#list contributors as contributor>
							<li><ul class="list-inline"><@displayContributorURL name=contributor /></ul></li>
						</#list>
					</ul>
				</div>	
				</#if>
				
				<div class="mb40">	
					<#if parentPage.title?has_content>				
						<ul class="list-unstyled">
							<li><h4 class="sidebar-title">ParentPage </h4><@displayURL name=parentPage.title /></li>
						</ul>
					</#if>
					
					<#if childPagesList?size != 0>
						<h4 class="sidebar-title">ChildPages (${childPages.childPagesCount})</h4>
						<ul class="list-unstyled">
							<#list childPagesList as childPage>
								<li><@displayURL name=childPage.title /></li>
							</#list>
						</ul>
					</#if>
				</div>

				<#if linkedPages?size != 0>
					<div class="mb40">	
						<h4 class="sidebar-title">LinkedPages</h4>
						<ul class="list-unstyled">
							<#list linkedPages?keys as prop>
								<li>$<@displayLinkedPages title=prop link=linkedPages[prop] /></li>
							</#list>
						</ul>
					</div>
				</#if>
					
				<div class="mb40">					
					<ul class="list-inline">
						<#if categories?has_content>
							<li><span class="glyphicon glyphicon-tag"></span>
								<#list categories as category>
									<@displayCategory
										category=category
									/>
								</#list>
							</li>
						</#if>
						<#if tags?has_content>
							<li><span class="glyphicon glyphicon-tags"></span>
								<#list tags as tag>
									<@displayTag
										tag=tag
									/>
								</#list>
							</li>
						</#if>
					</ul>	
				</div>
			</div>
		</div>
	</div>
<#if entry.getAttachmentsFileEntriesCount() gt 0>
	<div class="row attachments content">
		<h4 class="text-default">Attachments</h4>
		<@displayAttachmentSection/>
	</div>
</#if>
<div class="comments content">
	<h4 class="text-default">Comments</h4>
	<@displayComments/>
</div>

<#macro displayTaskFlagging>
   <#if availableTasks?has_content>
    <a class="btn btn-default btn-block" data-placement="right" title="Outdated" data-animation="true" href="javascript:;" id="myPopoverAnim"><span class="glyphicon glyphicon-flag"> </span></a>
   </#if>
</#macro>

<#macro displayEditLink>
	<#assign editPageURL = renderResponse.createRenderURL() />
	${editPageURL.setParameter("mvcRenderCommandName", "/wiki/edit_page")}
	${editPageURL.setParameter("redirect", currentURL)}
	${editPageURL.setParameter("nodeId", entry.getNodeId()?string)}
	${editPageURL.setParameter("title", entry.getTitle()?trim)}

	<a class="btn btn-default btn-block" data-toggle="tooltip" data-placement="right" title="Edit" data-animation="true" href="${editPageURL?string?trim}"><span class="glyphicon glyphicon-edit"> </span></a>
</#macro>
<#macro displayFriendlyURL
	name
>
	<#assign wikiTitle = getNormalizedWikiName(name)>
	<a class="btn btn-default btn-block" data-toggle="tooltip" data-placement="right" title="Permalink" data-animation="true" href="${portalURL}${pageFriendlyURL}/${wikiTitle}"><span class="glyphicon glyphicon-link"> </span></a>
</#macro>
<#macro displayURL
	name
>
	<#assign wikiTitle = getNormalizedWikiName(name)>
	<a class="" data-toggle="tooltip" data-placement="right" title="Permalink" data-animation="true" href="${portalURL}${pageFriendlyURL}/${wikiTitle}">${name} <span class="glyphicon glyphicon-link"> </span></a>
</#macro>
<#macro displayUserURL
	name
>
	<#assign wikiTitle = getNormalizedWikiName(name.userScreenName)>
	<a class="" data-animation="true" href="${portalURL}${pubFriendlyURL}/${wikiTitle}"><span class="glyphicon glyphicon-user"> </span> ${name.userScreenName}  -  <span class="glyphicon glyphicon-calendar"> </span> ${name.date?date}</a>
</#macro>
<#macro displayContributorURL
    name
>
	<#assign date = name.date>
	
	<li><span class="glyphicon glyphicon-user"></span> <a class="" data-animation="true" href="${portalURL}${pubFriendlyURL}/${name.userScreenName}"> ${name.userFullName} </a></li>
	<li><span class="glyphicon glyphicon-calendar"> </span> ${date}</li>

</#macro>
<#macro displayPageDetails>
	<#assign viewPageDetailsURL = renderResponse.createRenderURL() />
	${viewPageDetailsURL.setParameter("mvcRenderCommandName", "/wiki/view_page_details")}
	${viewPageDetailsURL.setParameter("title", entry.getTitle()?trim)}
	${viewPageDetailsURL.setParameter("redirect", currentURL)}

	<a class="btn btn-default btn-block" href="${viewPageDetailsURL?string?trim}"><span class="glyphicon glyphicon-info-sign" data-toggle="tooltip" data-placement="right" title="Details" data-animation="true"> </span></a>
</#macro>
<#macro displayAddChildLink>
	<#assign addPageURL = renderResponse.createRenderURL() />
	${addPageURL.setParameter("mvcRenderCommandName", "/wiki/edit_page")}
	${addPageURL.setParameter("redirect", currentURL)}
	${addPageURL.setParameter("nodeId", entry.getNodeId()?string)}
	${addPageURL.setParameter("title", "")}
	${addPageURL.setParameter("editTitle", "1")}
	${addPageURL.setParameter("parentTitle", entry.getTitle())}

	<a class="btn btn-default btn-block" href="${addPageURL?string}"><span class="glyphicon glyphicon-plus" data-toggle="tooltip" data-placement="right" title="Add Child page" data-animation="true"> </span></a>
</#macro>
<#macro displayPageSubscription>
	<#if isSubscribedPage>
		<#assign unsubscribeURL = renderResponse.createActionURL()>
		${unsubscribeURL.setParameter("javax.portlet.action", "/wiki/edit_page")}
		${unsubscribeURL.setParameter("cmd", "unsubscribe")}
		${unsubscribeURL.setParameter("redirect", currentURL)}
		${unsubscribeURL.setParameter("nodeId", entry.getNodeId()?string)}
		${unsubscribeURL.setParameter("title", entry.getTitle()?string)}

		<a class="btn btn-default btn-block" href="${unsubscribeURL?string}"><span class="glyphicon glyphicon-remove" data-toggle="tooltip" data-placement="right" title="Unsubscribe" data-animation="true"> </span></a>
	<#else>
		<#assign subscribeURL = renderResponse.createActionURL()>
		${subscribeURL.setParameter("javax.portlet.action", "/wiki/edit_page")}
		${subscribeURL.setParameter("cmd", "subscribe")}
		${subscribeURL.setParameter("redirect", currentURL)}
		${subscribeURL.setParameter("nodeId", entry.getNodeId()?string)}
		${subscribeURL.setParameter("title", entry.getTitle()?string)}

		<a class="btn btn-default btn-block" href="${subscribeURL?string}"><span class="glyphicon glyphicon-ok" data-toggle="tooltip" data-placement="right" title="Subscribe" data-animation="true"> </span></a>
	</#if>
</#macro>
<#macro displayAttachmentSection>
	<#assign message = "attachments">
	<#if entry.getAttachmentsFileEntriesCount() == 1>
		<#assign message = "attachment">
	</#if>
	<#assign attachments = entry.getAttachmentsFileEntries()>
	<a data-toggle="collapse" href="#attachmentsCollapse" aria-expanded="false" aria-controls="collapseExample">
	<span class="glyphicon glyphicon-paperclip"> </span>
	${entry.getAttachmentsFileEntriesCount()} ${message} <span class="caret"> </span></a><br>
	<div class="collapse" id="attachmentsCollapse">
		<div class="table-responsive">
			<table class="table table-condensed table-hover table-striped table-responsive">
			<tbody>
				<tr>
					<th>Filename</th>
					<th>Size</th>
				</tr>
				<#list attachments as file>
					<#assign downloadURL = portalURL + "/documents/portlet_file_entry/" + file.getGroupId() + "/" + file.getFileName() + "/" + file.getUuid() + "?status=0&download=true">
					<#assign tooltip = "false">
					<#assign title = file.getTitle()>
						<#if title?length gt 60>
							<#assign tooltipMsg = title>
							<#assign title = title[0..50] + "(...)." + file.getExtension()>
							<#assign tooltip = "true">
						</#if>
					<tr>
						<td>
							<#if tooltip == "true">
									<a href="${downloadURL}" data-toggle="tooltip" data-placement="top" title="${tooltipMsg}" data-animation="true">${title}</a>
							<#else>
									<a href="${downloadURL}">${title}</a>
							</#if>
						</td>
						<#assign size = file.getSize()>
						<#assign unit = "B">
						<#if size gt 1000>
							<#assign size = size / 1024>
							<#assign unit = "Kb">
						</#if>
						<#if size gt 1000>
							<#assign size = size / 1024>
							<#assign unit = "Mb">
						</#if>
						<td>${size?string["0.##"]} ${unit}</td>
					</tr>
				</#list>
				</tbody>
			</table>
		</div>
	</div>
</#macro>

<#macro getRatings>
	<@liferay_ui["ratings"]
		className=wikiPageClassName
		classPK=entry.getResourcePrimKey()
	/>
</#macro>
<#macro displayComments>
	<@liferay_ui["discussion"]
		className=wikiPageClassName
		classPK=entry.getResourcePrimKey()
		formAction="/c/portal/comment/edit_discussion"
		formName="fm2"
		ratingsEnabled=wikiPortletInstanceOverriddenConfiguration.enableCommentRatings()
		redirect=currentURL
		subject=entry.getTitle()
		userId=assetRenderer.getUserId()
	/>
</#macro>
<#macro displayWikiSubscription>
	<#if isSubscribedWiki>
		<#assign unsubscribeURL = renderResponse.createActionURL()>
		${unsubscribeURL.setParameter("javax.portlet.action", "/wiki/edit_node")}
		${unsubscribeURL.setParameter("cmd", "unsubscribe")}
		${unsubscribeURL.setParameter("redirect", currentURL)}
		${unsubscribeURL.setParameter("nodeId", entry.getNodeId()?string)}

		<a href="${unsubscribeURL?string}"><span class="glyphicon glyphicon-remove"> </span> Unsubscribe</a> from this wiki.
	<#else>
		<#assign subscribeURL = renderResponse.createActionURL()>
		${subscribeURL.setParameter("javax.portlet.action", "/wiki/edit_node")}
		${subscribeURL.setParameter("cmd", "subscribe")}
		${subscribeURL.setParameter("redirect", currentURL)}
		${subscribeURL.setParameter("nodeId", entry.getNodeId()?string)}

		<a href="${subscribeURL?string}"><span class="glyphicon glyphicon-ok"> </span> Subscribe</a> to this wiki.
	</#if>
</#macro>
<#macro displayTag
	tag
>
	<#assign tagRenderURL = renderResponse.createRenderURL()>
	<#assign tagName = tag.getName()>
	${tagRenderURL.setParameter("mvcRenderCommandName", "/wiki/view_tagged_pages")}
	${tagRenderURL.setParameter("nodeId", entry.getNodeId()?string)}
	${tagRenderURL.setParameter("tag", tagName)}

	<a href="${tagRenderURL}">${tagName}</a>
</#macro>
<#macro displayContributors
	contributor
>
    <#assign author = contributor>
    <li>${author}</li>
</#macro>
<#macro displayCategory
	category
>
	<#assign categoryRenderURL = renderResponse.createRenderURL()>
	${categoryRenderURL.setParameter("mvcRenderCommandName", "/wiki/view_categorized_pages")}
	${categoryRenderURL.setParameter("nodeId", entry.getNodeId()?string)}
	${categoryRenderURL.setParameter("categoryId", category.getCategoryId()?string)}

	<a href="${categoryRenderURL}">${category.getName()}</a>
</#macro>
<#macro displayLinkedPages
	title link
>
	<a class="" data-toggle="tooltip" data-placement="right" title="Permalink" data-animation="true" href="${link}">${title} <span class="glyphicon glyphicon-link"> </span></a>
</#macro>
<#function getNormalizedWikiName string>
	<#return string?replace("�", "a")?replace("�","e")?replace("�","i")?replace("[�|�|�]", "u", "r")?replace("[�|�|�]", "o", "r")?replace("&", "<AMPERSAND>")?replace("'", "<APOSTROPHE>")?replace("@", "<AT>")?replace("]", "<CLOSE_BRACKET>,")?replace(")", "<CLOSE_PARENTHESIS>")?replace(":", "<COLON>")?replace(",", "<COMMA>")?replace("$", "<DOLLAR>")?replace("=", "<EQUAL>")?replace("!", "<EXCLAMATION>")?replace("[", "<OPEN_BRACKET>")?replace("(", "<OPEN_PARENTHESIS>")?replace("#", "<POUND>")?replace("?", "<QUESTION>")?replace(";", "<SEMICOLON>")?replace("/", "<SLASH>")?replace("*", "<STAR>")?replace("+","<PLUS>")?replace(" ","+")>
</#function>
