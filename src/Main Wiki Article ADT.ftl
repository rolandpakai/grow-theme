<script type="text/javascript">
	$(function () {
		$('[data-toggle="tooltip"]').tooltip()
	});
	$(document).ready(function () {
		$(".wiki-actions .rating-thumb-up").addClass("btn btn-default btn-block");
		$(".wiki-actions .rating-thumb-up").removeClass("btn-outline-borderless btn-outline-secondary btn-sm rating-thumb-up");

		if ($(".wiki-actions .votes").text() >= 10) {
			$(".wiki-actions .rating-element .inline-item").addClass("votes-padding");
		}

		$(".wiki-body #sidebar").click(function(){ 
			$("#wiki-content-main").toggleClass("col-md-12");
			$("#wiki-content-sidebar").toggle();
		});
	});
</script>
<#setting url_escaping_charset='UTF-8'>
<#assign WikiHelperService = serviceLocator.findService("com.liferay.grow.wiki.helper.service.WikiHelperService")>
<#assign JSONFactoryUtil = serviceLocator.findService("com.liferay.portal.kernel.json.JSONFactoryUtil")>
<#assign UserLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.UserLocalService")>
<#assign AssetTagLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetTagLocalService")>
<#assign SubscriptionLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.SubscriptionLocalService")>

<#assign contributors = WikiHelperService.getWikiPageContributors(entry.getNodeId(), entry.getTitle())>
<#assign contributorsList = JSONFactoryUtil.looseDeserialize(contributors.contributors)>
<#assign creatorUser = JSONFactoryUtil.looseDeserialize(contributors.creator)>
<#assign parentPage = WikiHelperService.getParentWikiPage(entry.getNodeId(), entry.getTitle())>
<#assign childPages = WikiHelperService.getChildWikiPages(entry.getNodeId(), entry.getTitle())>
<#assign childPagesList = JSONFactoryUtil.looseDeserialize(childPages.childPages)>
<#assign linkedPages = WikiHelperService.getLinkedPages(entry.getNodeId(), entry.getTitle())>
<#assign linkedPagesList = JSONFactoryUtil.looseDeserialize(linkedPages.linkedPages)>

<#assign wikiPageClassName = "com.liferay.wiki.model.WikiPage" >
<#assign wikiNodeClassName = "com.liferay.wiki.model.WikiNode" >
<#assign isSubscribedPage = SubscriptionLocalService.isSubscribed(entry.getCompanyId(), themeDisplay.getUserId(), wikiPageClassName, entry.getResourcePrimKey())>
<#assign isSubscribedWiki = SubscriptionLocalService.isSubscribed(entry.getCompanyId(), themeDisplay.getUserId(), wikiNodeClassName, entry.getNodeId())>
<#assign tags = AssetTagLocalService.getAssetEntryAssetTags(assetEntry.getEntryId())>
<#assign modifierUser = UserLocalService.getUser(entry.getStatusByUserId())>
<#assign assetRenderer = assetEntry.getAssetRenderer() />

<#assign serviceContext = staticUtil["com.liferay.portal.kernel.service.ServiceContextThreadLocal"].getServiceContext()>
<#assign httpServletRequest = serviceContext.getRequest()>
<#assign portalURL = portal.getPortalURL(httpServletRequest)>
<#assign siteFriendlyURL = themeDisplay.getSiteGroup().getFriendlyURL()>
<#assign pageFriendlyURL = themeDisplay.getLayout().getFriendlyURL()>
<#assign pubFriendlyURL = prefsPropsUtil.getString(companyId, "layout.friendly.url.public.servlet.mapping")>
<#assign privateFriendlyURL = prefsPropsUtil.getString(companyId, "layout.friendly.url.private.group.servlet.mapping")>
<#if entry.getParentPage()?has_content>
	<#assign parentTitle = entry.getParentPage().getTitle()>
</#if>

<#if tags?has_content>
	<#list tags as tag>
		<#if tag.name?matches("official", "i")>
			<#assign official="true">
		</#if>
	</#list>
</#if>

	<div class="row wiki-body">
		<div id="wiki-content-main" class="col-md-9 px-3">
			<div class="wiki-inner">
				<div class="wiki-actions">
					<ul class="list-unstyled">
						<li><@displayEditLink/></li>
						<li><@displayFriendlyURL name=entry.getTitle() /></li>
						<li><@displayAddChildLink/></li>
						<li><@displayPageSubscription/></li>
						<li><@displayPageDetails/></li>
						<li><@getRatings/></li>
					</ul>
				</div>
				<h1 class="text-default">
					<#if official?has_content>
						<span class="">
							<i class="icon-check"></i>
							<span class="taglib-text hide-accessible"></span>
						</span>
					</#if>
					${entry.getTitle()}
				</h1>
				<div>
					${formattedContent}
				</div>
			</div>
		</div>	
		<div id="wiki-content-sidebar" class="col-md-3 sidebar">
			<div class="sidebar-box">

				<nav class="a-items">
					<input type="checkbox" name="contributors" id="contributors" class="activate hidden"/>
					<label for="contributors" class="accordion-label">Contributors</label>
					<div class="sbox a-content">
						<ul class="list-unstyled">
							<li>
								<span class="glyphicon glyphicon-eye-open"></span> ${assetEntry.getViewCount()}
							</li>
							<li>
								<table class="contributors-table">
									<#if modifierUser?has_content>
										<tr>	
											<td><span class="glyphicon glyphicon-user"></span> Updated by <a href="${portal.getPortalURL(httpServletRequest) + pubFriendlyURL + "/" + modifierUser.getScreenName()}">${modifierUser.getFullName()}</a> </td>
											<td class="last-td"><span class="glyphicon glyphicon-calendar"> </span> ${assetEntry.getModifiedDate()?date}</li>	
										</tr>
									</#if>
									<#if creatorUser?has_content>
										<tr>
											<td><span class="glyphicon glyphicon-user"></span> Creator: <a href="${portal.getPortalURL(httpServletRequest) + pubFriendlyURL + "/" + creatorUser.userScreenName}">${creatorUser.userFullName}</a> (${creatorUser.count})</td>
											<td class="last-td"><span class="glyphicon glyphicon-calendar"> </span> ${contributors.creator.date?date}</td>
										</tr>
									</#if>
								</table>	
							</li>	
							<#if contributorsList?size != 0>
								<#list contributorsList as contributor>
									<#if contributor?has_content>
										<li><@displayContributorURL contributor /></li>
									</#if>
								</#list>
							</#if>
							<li><@displayPageActivities/></li>
						</ul>			
					</div>
				</nav>

				<nav class="a-items">
					<input type="checkbox" name="tags" id="tags" class="activate hidden"/>
					<label for="tags" class="accordion-label">Tags</label>
					<div class="sbox a-content">
						<ul class="list-unstyled">
							<#if tags?has_content>
							    <#if official?has_content>
									<li>
										<span class="glyphicon glyphicon-check"></span> 
										<@displayTag tagName="official"/>
									</li>
								</#if>
								<li>
									<span class="glyphicon glyphicon-tags"></span>
									<#list tags as tag>
										<#if !(tag.name?matches("official", "i"))>
											<@displayTag tagName=tag.name/>
										</#if>	
									</#list>
								</li>
							</#if>
						</ul>
					</div>
				</nav>					

				<nav class="a-items">
					<input type="checkbox" name="pages" id="pages" class="activate hidden"/>
					<label for="pages" class="accordion-label">Pages</label>
					<div class="sbox a-content">	
						<ul class="list-unstyled">
							<#if parentPage.title?has_content>				
								<li><@displayParentPageURL name=parentPage.title /></li>
							</#if>
							<#if childPagesList?size != 0>
								<#list childPagesList as childPage>
									<#if childPage.title?has_content>	
										<li><@displayPageURL name=childPage.title glyphicon="triangle-bottom"/></li>
									</#if>
								</#list>
							</#if>
							
							<li class="loadmore pb10">
								<!--<span class="glyphicon glyphicon-option-horizontal pr10"></span><a href="#" onclick="alert('load more');">load more</a>-->
							</li>
							
							<#if linkedPagesList?size != 0>
								<#list linkedPagesList as linkedPage>
									<#if linkedPage.title?has_content>	
										<li><@displayPageURL name=linkedPage.title glyphicon="link"/></li>
									</#if>
								</#list>
							</#if>
							
							<li class="loadmore">
								<!--<span class="glyphicon glyphicon-option-horizontal pr10"></span><a href="#" onclick="alert('load more');">load more</a>-->
							</li>						
						</ul>
					</div>
				</nav>	
				<#if entry.getAttachmentsFileEntriesCount() gt 0>
					<nav class="a-items">
						<input type="checkbox" name="attachments" id="attachments" class="activate hidden"/>
						<label for="attachments" class="accordion-label">Attachments</label>
						<div class="sbox a-content">
							<ul class="list-unstyled">
								<@displayAttachmentAccordion />
							</ul>
						</div>
					</nav>
				</#if>
			</div>
		</div>
		<div class="sidebar-button">
			<input type="checkbox" name="sidebar" id="sidebar" class="hidden"/> 
			<label class="sidebar-label" for="sidebar"></label>
		</div>
	</div>

	<@displayComments />


<#--   macros   -->

<#macro displayEditLink>
	<#assign editPageURL = renderResponse.createRenderURL() />
	${editPageURL.setParameter("mvcRenderCommandName", "/wiki/edit_page")}
	${editPageURL.setParameter("redirect", currentURL)}
	${editPageURL.setParameter("nodeId", entry.getNodeId()?string)}
	${editPageURL.setParameter("title", entry.getTitle()?trim)}

	<a class="btn btn-default btn-block" data-toggle="tooltip" data-placement="right" title="Edit" data-animation="true" href="${editPageURL?string?trim}"><span class="glyphicon glyphicon-edit"> </span></a>
</#macro>

<#macro displayComments>
<div id="wikiComments" class="px-3">
	<@liferay_ui["panel-container"]
		extended=false
		markupView="lexicon"
		persistState=true
	>
		<@liferay_ui["panel"]
			collapsible=true
			extended=true
			id="wikiCommentsPanel"
			markupView="lexicon"
			persistState=true
			title="comments"
		>
			<@liferay_comment["discussion"]
				className=wikiPageClassName
				classPK=entry.getResourcePrimKey()
				formName="fm2"
				ratingsEnabled=wikiPortletInstanceOverriddenConfiguration.enableCommentRatings()
				redirect=currentURL
				userId=assetRenderer.getUserId()
			>
			</@>
		</@>
	</@>
</div>	
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
	<span class="glyphicon glyphicon-link"> </span> <a class="" data-toggle="tooltip" data-placement="right" title="Permalink" data-animation="true" href="${portalURL}${pageFriendlyURL}/${wikiTitle}">${name}</a>
</#macro>

<#macro displayParentPageURL
	name
>
	<#assign wikiTitle = getNormalizedWikiName(name)>
	<#assign tooltip = "false">
	<#assign title = name>
	<#assign tooltipMsg = name>
	<#if title?length gt 37>
		<#assign title = title[0..32] + "...">
		<#assign tooltip = "true">
	</#if>

	<span class="glyphicon glyphicon-triangle-top"> </span> 
	
	<#if tooltip == "true">
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}" data-toggle="tooltip" data-placement="top" title="${tooltipMsg}" data-animation="true">${title}</a>
	<#else>
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}">${title}</a>
	</#if>
</#macro>

<#macro displayPageURL
	name glyphicon
>
	<#assign wikiTitle = getNormalizedWikiName(name)>
	<#assign tooltip = "false">
	<#assign title = name>
	<#assign tooltipMsg = name>
	<#if title?length gt 37>
		<#assign title = title[0..32] + "...">
		<#assign tooltip = "true">
	</#if>

	<span class="glyphicon glyphicon-${glyphicon}"> </span> 
	
	<#if tooltip == "true">
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}" data-toggle="tooltip" data-placement="top" title="${tooltipMsg}" data-animation="true">${title}</a>
	<#else>
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}">${title}</a>
	</#if>
</#macro>

<#macro displayUserURL
	name
>
	<#assign wikiTitle = getNormalizedWikiName(name.userScreenName)>

	<a class="" data-animation="true" href="${portalURL}${pubFriendlyURL}/${wikiTitle}"><span class="glyphicon glyphicon-user"> </span> ${name.userScreenName}  -  <span class="glyphicon glyphicon-calendar"> </span> ${name.date?date}</a>
</#macro>

<#macro displayContributorURL
    contributor
>
	<span class="glyphicon glyphicon-user"></span> <a class="" data-animation="true" href="${portalURL}${pubFriendlyURL}/${contributor.userScreenName}"> ${contributor.userFullName} </a> (${contributor.count})
</#macro>

<#macro displayPageDetails>
	<#assign viewPageDetailsURL = renderResponse.createRenderURL() />
	${viewPageDetailsURL.setParameter("mvcRenderCommandName", "/wiki/view_page_details")}
	${viewPageDetailsURL.setParameter("title", entry.getTitle()?trim)}
	${viewPageDetailsURL.setParameter("redirect", currentURL)}

	<a class="btn btn-default btn-block" href="${viewPageDetailsURL?string?trim}"><span class="glyphicon glyphicon-info-sign" data-toggle="tooltip" data-placement="right" title="Details" data-animation="true"> </span></a>
</#macro>

<#macro displayPageActivities>
	<#assign viewPageActivitiesURL = renderResponse.createRenderURL() />
	${viewPageActivitiesURL.setParameter("mvcRenderCommandName", "/wiki/view_page_activities")}
	${viewPageActivitiesURL.setParameter("title", entry.getTitle()?trim)}
	${viewPageActivitiesURL.setParameter("redirect", currentURL)}

	<span class="glyphicon glyphicon-list"></span> <a class="" href="${viewPageActivitiesURL?string?trim}">View history</a>
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

<#macro displayAttachmentAccordion>
	<#assign attachments = entry.getAttachmentsFileEntries()>
	<#list attachments as file>
		<#assign downloadURL = portalURL + "/documents/portlet_file_entry/" + file.getGroupId() + "/" + file.getFileName()?url + "/" + file.getUuid() + "?status=0&download=true">
		<#assign tooltip = "false">
		<#assign title = file.getTitle()>
		<#assign tooltipMsg = title>
		<#if title?length gt 28>
			<#assign title = title[0..23] + "(...)." + file.getExtension()>
			<#assign tooltip = "true">
		</#if>
 
		<li>
			<span class="glyphicon glyphicon-paperclip"></span>
 
			<#if tooltip == "true">
				<a href="${downloadURL}" data-toggle="tooltip" data-placement="top" title="${tooltipMsg}" data-animation="true">${title}</a>
			<#else>
				<a href="${downloadURL}">${title}</a>
			</#if>
 			
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
 
			<span> (${size?string["0.##"]} ${unit})</span>
		</li>
	</#list>
</#macro>

<#macro getRatings>
	<@liferay_ui["ratings"]
		className=wikiPageClassName
		classPK=entry.getResourcePrimKey()
	/>
</#macro>

<#macro displayComments>
<div id="wikiComments" class="px-3">
	<@liferay_ui["panel-container"]
		extended=false
		markupView="lexicon"
		persistState=true
	>
		<@liferay_ui["panel"]
			collapsible=true
			extended=true
			id="wikiCommentsPanel"
			markupView="lexicon"
			persistState=true
			title="comments"
		>
			<@liferay_comment["discussion"]
				className=wikiPageClassName
				classPK=entry.getResourcePrimKey()
				formName="fm2"
				ratingsEnabled=wikiPortletInstanceOverriddenConfiguration.enableCommentRatings()
				redirect=currentURL
				userId=assetRenderer.getUserId()
			>
			</@>
		</@>
	</@>
</div>	

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
	tagName
>
	<#assign tagRenderURL = renderResponse.createRenderURL()>
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

<#--   functions   -->

<#function getNormalizedWikiName string>
	<#return string?replace("á", "a")?replace("é","e")?replace("í","i")?replace("[ú|ü|ű]", "u", "r")?replace("[ó|ö|ő]", "o", "r")?replace("&", "<AMPERSAND>")?replace("'", "<APOSTROPHE>")?replace("@", "<AT>")?replace("]", "<CLOSE_BRACKET>,")?replace(")", "<CLOSE_PARENTHESIS>")?replace(":", "<COLON>")?replace(",", "<COMMA>")?replace("$", "<DOLLAR>")?replace("=", "<EQUAL>")?replace("!", "<EXCLAMATION>")?replace("[", "<OPEN_BRACKET>")?replace("(", "<OPEN_PARENTHESIS>")?replace("#", "<POUND>")?replace("?", "<QUESTION>")?replace(";", "<SEMICOLON>")?replace("/", "<SLASH>")?replace("*", "<STAR>")?replace("+","<PLUS>")?replace(" ","+")>
</#function>
