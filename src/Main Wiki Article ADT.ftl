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

<#if entry.getFormat() == "markdown">
	<#assign CSS = "markdown-body">
<#else>
	<#assign CSS = "html-creole-body">
</#if>

<#if tags?has_content>
	<#list tags as tag>
		<#if tag.name?matches("official", "i")>
			<#assign official="true">
		</#if>
	</#list>
</#if>

<div class="row grow-wiki-body">
	<div id="wiki-content-main" class="col-md-9 px-3">
		<div class="wiki-inner">
		
			<div class="wiki-header-toolbar">
				<div class="autofit-col">
					<div class="autofit-section">
						<button id="editButton" class="btn btn-outline-secondary btn-outline-borderless" type="button" title="Edit">
							<svg class="lexicon-icon pencil lexicon-icon-pencil"  focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-body" fill="none" d="M483,31C466.9,14.9,445.5,6,422.8,6s-44.1,8.9-60.2,24.9L4.1,389.4l4.4,115.3l119.9,1.2L483,151.4  C516.2,118.2,516.2,64.2,483,31L483,31z"></path>
								<path class="lexicon-icon-outline" d="M483,31C466.9,14.9,445.5,6,422.8,6s-44.1,8.9-60.2,24.9L4.1,389.4l4.4,115.3l119.9,1.2L483,151.4  C516.2,118.2,516.2,64.2,483,31L483,31z M105.1,449l-42-0.4l-1.4-36.5l274.4-274.4l40.1,40.1L105.1,449L105.1,449z M442.9,111.2  l-26.4,26.4l-40.1-40.1l26.4-26.4c10.7-10.7,29.4-10.7,40.1,0C453.9,82.2,453.9,100.2,442.9,111.2z"></path>
							</svg>
						</button>
						<button id="permalinkButton" class="btn btn-outline-secondary btn-outline-borderless" type="button" title="Permalink">
							<svg class="lexicon-icon link lexicon-icon-link"  focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-outline" d="M285.057 320.303c-24.563 0-49.097-9.328-67.78-28.039-9.667-9.666-9.667-25.326 0-34.964 9.667-9.666 25.326-9.666 34.965 0 18.062 18.062 47.486 18.090 65.576 0l122.474-122.445c18.062-18.061 18.062-47.486-0.029-65.576-8.762-8.762-20.408-13.596-32.788-13.596v0c-12.38 0-23.997 4.805-32.76 13.567l-100.512 100.511c-9.666 9.666-25.326 9.666-34.964 0-9.666-9.666-9.666-25.326 0-34.964l100.512-100.511c18.090-18.090 42.144-28.067 67.724-28.067h0.029c25.58 0 49.663 9.978 67.752 28.067 37.366 37.367 37.366 98.166 0.029 135.504l-122.474 122.445c-18.683 18.712-43.218 28.067-67.752 28.067z"></path>
								<path class="lexicon-icon-outline" d="M105.882 499.619c-0.056 0-0.085 0-0.141 0-25.552-0.029-49.606-10.005-67.696-28.096-37.367-37.366-37.423-98.109-0.142-135.391l122.587-122.587c37.367-37.367 98.166-37.339 135.504 0.029 9.666 9.666 9.666 25.326 0 34.964-9.666 9.666-25.326 9.666-34.964 0-18.090-18.090-47.486-18.090-65.576-0.029l-122.587 122.587c-18.005 18.005-17.92 47.344 0.141 65.435 8.762 8.762 20.408 13.596 32.788 13.623 0.028 0 0.056 0 0.085 0 12.323 0 23.885-4.777 32.59-13.483l100.257-100.257c9.667-9.666 25.326-9.666 34.965 0 9.666 9.666 9.666 25.326 0 34.964l-100.257 100.257c-18.034 18.062-42.002 27.983-67.555 27.983z"></path>
							</svg>
						</button>
						<button id="childrenButton" class="btn btn-outline-secondary btn-outline-borderless button-children" type="button" title="Child pages">
							<svg class="lexicon-icon pages-tree lexicon-pages-tree"  focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-outline pages-tree-tree" d="M161.5,288h126c0,17.6,14.4,32,32,32h64c17.8,0,32-14.4,32-32v-64c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v32h-126V128h32c17.8,0,32-14.4,32-32V32c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v64c0,17.6,14.4,32,32,32v352h158c0,17.6,14.4,32,32,32h64c17.8,0,32-14.4,32-32v-64c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v32h-126V288z"></path>
							</svg>
						</button>
						<button id="detailsButton" class="btn btn-outline-secondary btn-outline-borderless button-details" type="button" title="Details">
							<svg class="lexicon-icon info-circle lexicon-icon-info-circle"  focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-outline" d="M437,75C388.7,26.6,324.4,0,256,0C187.6,0,123.3,26.6,75,75C26.6,123.3,0,187.6,0,256c0,68.4,26.6,132.7,75,181  c48.4,48.4,112.6,75,181,75c68.4,0,132.7-26.6,181-75c48.4-48.4,75-112.6,75-181C512,187.6,485.4,123.3,437,75z M288,384  c0,17.7-14.3,32-32,32c-17.7,0-32-14.3-32-32V224c0-17.7,14.3-32,32-32c17.7,0,32,14.3,32,32V384z M256,160c-17.7,0-32-14.3-32-32  c0-17.7,14.3-32,32-32s32,14.3,32,32C288,145.7,273.7,160,256,160z"></path>
							</svg>
						</button>
					</div>
				</div>
			</div>
			
			
			<div class="wiki-title">
				<#if official?has_content>
					<span class="">
						<i class="icon-check"></i>
						<span class="taglib-text hide-accessible"></span>
					</span>
				</#if>
				${entry.getTitle()}
			</div>
			
			<div class="wiki-author-details">
				<#if modifierUser?has_content>
					<ul class="list-unstyled">
						<li><a href="${portal.getPortalURL(httpServletRequest) + pubFriendlyURL + "/" + modifierUser.getScreenName()}">${modifierUser.getFullName()}</a>,</li>
						<li>${assetEntry.getModifiedDate()?date}</li>
						<li>- ${assetEntry.getViewCount()} Views</li>
					</ul>
				</#if>
			</div>
			
			<div class="${CSS}">
				${formattedContent}
			</div>
			
			<div class="wiki-footer-toolbar">
				<div class="autofit-col">
					<div class="autofit-section">
						<button id="outdateButton" class="btn btn-outline-secondary btn-outline-borderless" type="button" title="Outdated">
							<svg class="lexicon-icon flag-full lexicon-icon-flag-full"  focusable="false" role="presentation" viewBox="0 0 512 512">
							<path class="lexicon-icon-body" d="M415,32H160c0-17.7-14.3-32-32-32S96,14.3,96,32v33v190.2V480c0,17.7,14.3,32,32,32s32-14.3,32-32V288h255  c18.2,0,33-14.8,33-33V65C448,46.8,433.2,32,415,32z"></path>
							<path class="lexicon-icon-outline" d="M415,32H160c0-17.7-14.3-32-32-32S96,14.3,96,32v33v190.2V480c0,17.7,14.3,32,32,32s32-14.3,32-32V288h255  c18.2,0,33-14.8,33-33V65C448,46.8,433.2,32,415,32z M384,224H160V96h224V224L384,224z"></path>
							</svg>
						</button>
						<button id="likeButton" class="btn btn-outline-secondary btn-outline-borderless" type="button" title="Like">
							<svg class="lexicon-icon thumbs-up-liked lexicon-icon-thumbs-up" focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-body" fill="none" d="M503.3,185.2c-4.5-8.3-13.4-19.1-30.5-23.1c-8.1-1.9-16.2-1.9-24.8-1.9L339.8,160c4-9.1,7.6-18.6,10.7-29.4
									c14.7-40.9,13.3-77-4.1-102C333.5,10.2,313.1,0,288.9,0c-0.5,0-0.9,0-1.4,0l-0.2,0c-24,0.5-47.3,15.7-69.2,45.1
									c-12.6,16.8-21.2,33.5-22.6,36.4L138.1,192H96v320l215.8,0c21.8,0,54-12.5,80-31.1c36.2-25.9,56.1-60.3,56.1-96.9v-36
									c7.7-2.1,15.6-5.3,23.3-10.1c18.6-11.5,40.7-35,40.7-82C512,218,511.2,199.9,503.3,185.2z"></path>
								<path class="lexicon-icon-outline" d="M503.3,185.2c-4.5-8.3-13.4-19.1-30.5-23.1c-8.1-1.9-16.2-1.9-24.8-1.9L339.8,160c4-9.1,7.6-18.6,10.7-29.4
									c14.7-40.9,13.3-77-4.1-102C333.5,10.2,313.1,0,288.9,0c-0.5,0-0.9,0-1.4,0l-0.2,0c-24,0.5-47.3,15.7-69.2,45.1
									c-12.6,16.8-21.2,33.5-22.6,36.4L138.1,192H96v320l215.8,0c21.8,0,54-12.5,80-31.1c36.2-25.9,56.1-60.3,56.1-96.9v-36
									c7.7-2.1,15.6-5.3,23.3-10.1c18.6-11.5,40.7-35,40.7-82C512,218,511.2,199.9,503.3,185.2z M418.1,288c-0.6,0-1,0-1.4,0l-32.6-0.7
									V384c0,19.4-15.5,34.8-28.6,44.3c-18.6,13.5-38.5,19.5-43.7,19.7H160V256h17l75.4-145.3l0.3-0.6c0.1-0.1,5.8-11.7,14.6-24
									c11.3-15.8,19.4-21.2,21.9-22.2c3.8,0.1,4.4,1,4.7,1.3c3.3,4.7,4.9,20.4-4,44.5l-0.5,1.3l-0.4,1.3c-4.5,16.5-11.3,29.5-20.6,47.4
									c-2.9,5.6-5.9,11.3-9.1,17.8L236.1,224l211.3,0.1c0.6,10.1,0.6,24.4,0.6,31.9C448,275.2,442.9,288,418.1,288z"></path>
								<path class="lexicon-icon-outline" d="M32,192c-17.7,0-32,14.3-32,32v256c0,17.7,14.3,32,32,32s32-14.3,32-32V224C64,206.3,49.7,192,32,192z"></path>
							</svg>
						</button>
						<button id="favouriteButton" class="btn btn-outline-secondary btn-outline-borderless" type="button" title="Favourite">
							<svg class="lexicon-icon lexicon-icon-star-o" focusable="false" role="presentation" viewBox="0 0 512 512">
								<path class="lexicon-icon-body" fill="none" d="M508.753 190.647c-3.247-9.265-11.983-15.493-21.802-15.493h-150.106l-59.203-158.208c-3.378-9.027-12.010-14.992-21.644-14.992s-18.264 5.965-21.617 14.992l-59.203 158.208h-150.131c-9.819 0-18.555 6.202-21.802 15.493-3.247 9.265-0.264 19.558 7.417 25.682l120.966 96.234-55.534 162.88c-3.114 9.132-0.212 19.268 7.285 25.365 7.47 6.097 17.975 6.889 26.316 1.979l146.173-86.204 150.317 90.163c3.668 2.217 7.786 3.299 11.877 3.299 0.026 0 0.079 0 0.132 0 12.722-0.422 23.2-10.32 23.2-23.095 0-3.853-0.924-7.496-2.613-10.69l-58.252-163.83 120.807-96.103c7.68-6.097 10.663-16.417 7.417-25.682z"></path>
								<path class="lexicon-icon-outline" d="M418.1,510.1c-4.1,0-8.2-1.1-11.9-3.3l-150.3-90.2l-146.2,86.2c-8.3,4.9-18.8,4.1-26.3-2s-10.4-16.2-7.3-25.4l55.5-162.9
									l-121-96.2C3,210.2,0,199.9,3.3,190.6s12-15.5,21.8-15.5h150.1l59.2-158.2c3.4-9,12-15,21.6-15s18.2,6,21.6,15l59.2,158.2H487
									c9.8,0,18.6,6.2,21.8,15.5c3.2,9.3,0.3,19.6-7.4,25.7l-120.8,96.1l58.3,163.9c1.7,3.2,2.6,6.8,2.6,10.7c0,12.7-10.3,23.1-23.1,23.1
									C418.2,510.1,418.1,510.1,418.1,510.1L418.1,510.1z M256,366.6c4.1,0,8.2,1.1,11.9,3.3L374.7,434l-43.3-121.7
									c-3.3-9.3-0.3-19.7,7.4-25.8l82-65.2h-100c-9.6,0-18.3-6-21.6-15L256,90.9l-43.2,115.4c-3.4,9-12,15-21.6,15h-100l82,65.2
									c7.6,6.1,10.6,16.3,7.5,25.5L140,431.3l104.3-61.5C247.9,367.7,251.9,366.6,256,366.6L256,366.6z"></path>
							</svg>
						</button>
				</div>
			</div>
			
		</div>
			
		</div>
	</div>	
	<div id="wiki-content-sidebar" class="col-md-3 sidebar">
		<div class="sidebar-box">

			<nav class="a-items">
				<input type="checkbox" name="tags" id="tags" class="activate hidden"/>
				<label for="tags" class="accordion-label">
					<svg class="lexicon-icon lexicon-icon-tag" focusable="false" role="presentation" viewBox="0 0 512 512">
						<path class="lexicon-icon-body" fill="none" d="M512,94.9l0-1c-1.5-49.8-37-89.3-84.5-93.8L426,0H281.9C239,0,210.9,18.6,198,29.7l-0.9,0.8L25.5,202.2  C8.9,218.8-0.1,241.2,0,265.2c0.1,23.9,9.3,46.1,25.8,62.6l158.4,158.4c16.6,16.6,38.9,25.8,62.7,25.8c23.8,0,46.1-9.1,62.6-25.7  l167.3-167.4l0.8-0.9c13.2-15.4,35.3-47.9,34.4-92.6L512,94.9z M364,191c-11.6,11.6-31.7,11.6-43.3,0c-11.9-11.9-11.9-31.4,0-43.3  c5.8-5.8,13.5-9,21.7-9c8.2,0,15.9,3.2,21.7,9c5.8,5.8,9,13.5,9,21.7C373,177.5,369.8,185.2,364,191z"></path>
						<path class="lexicon-icon-outline" d="M512,94.9l0-1c-1.5-49.8-37-89.3-84.5-93.8L426,0H281.9C239,0,210.9,18.6,198,29.7l-0.9,0.8L25.5,202.2  C8.9,218.8-0.1,241.2,0,265.2c0.1,23.9,9.3,46.1,25.8,62.6l158.4,158.4c16.6,16.6,38.9,25.8,62.7,25.8c23.8,0,46.1-9.1,62.6-25.7  l167.3-167.4l0.8-0.9c13.2-15.4,35.3-47.9,34.4-92.6L512,94.9z M448,226.4c0.5,22.9-10.9,40.2-18.2,49L264.2,441.1  c-4.5,4.5-10.6,6.9-17.4,6.9c-6.8,0-12.9-2.4-17.4-7L71,282.6c-9.3-9.3-9.4-26-0.3-35.1L240.6,77.5c6.5-5.4,19.9-13.5,41.2-13.5  h140.8c14.4,2,24.7,14.7,25.3,31.4l0,130.2L448,226.4z"></path>
						<path class="lexicon-icon-outline" d="M294.6,121.6c-26.3,26.3-26.3,69.2,0,95.5c12.8,12.8,29.7,19.8,47.8,19.8c18.1,0,35-7,47.8-19.8  c12.8-12.8,19.8-29.7,19.8-47.8s-7-35-19.8-47.8C364.6,96.1,320.1,96,294.6,121.6z M364,191c-11.6,11.6-31.7,11.6-43.3,0  c-11.9-11.9-11.9-31.4,0-43.3c5.8-5.8,13.5-9,21.7-9s15.9,3.2,21.7,9s9,13.5,9,21.7C373,177.5,369.8,185.2,364,191z"></path>
					</svg>
					<span>Tags</span>
				</label>
				<div class="sbox a-content">
					<ul class="list-unstyled">
						<#if tags?has_content>
							<li>
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
				<label for="pages" class="accordion-label">
					<svg class="lexicon-icon pages-tree lexicon-pages-tree"  focusable="false" role="presentation" viewBox="0 0 512 512">
						<path class="lexicon-icon-outline pages-tree-tree" d="M161.5,288h126c0,17.6,14.4,32,32,32h64c17.8,0,32-14.4,32-32v-64c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v32h-126V128h32c17.8,0,32-14.4,32-32V32c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v64c0,17.6,14.4,32,32,32v352h158c0,17.6,14.4,32,32,32h64c17.8,0,32-14.4,32-32v-64c0-17.8-14.4-32-32-32h-64c-17.8,0-32,14.4-32,32v32h-126V288z"></path>
					</svg>
					<span>Child Pages</span>
				</label>
				<div class="sbox a-content">	
					<ul class="list-unstyled">
						<#if childPagesList?size != 0>
							<#list childPagesList as childPage>
								<#if childPage.title?has_content>	
									<li><@displayPageURL name=childPage.title glyphicon="" /></li>
								</#if>
							</#list>
						</#if>						
					</ul>
				</div>
			</nav>	
			<#if entry.getAttachmentsFileEntriesCount() gt 0>
				<nav class="a-items">
					<input type="checkbox" name="attachments" id="attachments" class="activate hidden"/>
					<label for="attachments" class="accordion-label">
						<svg class="lexicon-icon document lexicon-document"  focusable="false" role="presentation" viewBox="0 0 512 512">
							<path class="lexicon-icon-outline document-border" d="M320,64v64c0,17.7,14.3,32,32,32h64v288H96V64H320z M325.5,0H96C60.7,0,32,28.7,32,64v384c0,35.3,28.7,64,64,64h320c35.3,0,64-28.7,64-64V154.5c0-33.5-18-44.5-63.5-90S360,0,325.5,0L325.5,0z"></path>
							<path class="lexicon-icon-outline document-text-1" d="M336,256H176c-22,0-21-32,0-32h160C356,224,358,256,336,256z"></path>
							<path class="lexicon-icon-outline document-text-2" d="M336,320H176c-22,0-21-32,0-32h160C356,288,358,320,336,320z"></path>
							<path class="lexicon-icon-outline document-text-3" d="M272,384h-96c-22,0-21-32,0-32h96C292,352,294,384,272,384z"></path>
						</svg>
						<span>Attachments</span>
					</label>
					<div class="sbox a-content">
						<ul class="list-unstyled">
							<@displayAttachmentAccordion />
						</ul>
					</div>
				</nav>
			</#if>
		</div>
	</div>
</div>

<#--   macros   -->

<#macro displayEditLink>
<#assign editPageURL = renderResponse.createRenderURL() />
${editPageURL.setParameter("mvcRenderCommandName", "/wiki/edit_page")}${editPageURL.setParameter("redirect", currentURL)}${editPageURL.setParameter("nodeId", entry.getNodeId()?string)}${editPageURL.setParameter("title", entry.getTitle()?trim)}"${editPageURL?string?trim}"
</#macro>

<#macro displayFriendlyURL name >
<#assign wikiTitle = getNormalizedWikiName(name)>"${portalURL}${pageFriendlyURL}/${wikiTitle}"
</#macro>

<#macro displayPageDetails>
<#assign viewPageDetailsURL = renderResponse.createRenderURL() />
${viewPageDetailsURL.setParameter("mvcRenderCommandName", "/wiki/view_page_details")}${viewPageDetailsURL.setParameter("title", entry.getTitle()?trim)}${viewPageDetailsURL.setParameter("redirect", currentURL)}"${viewPageDetailsURL?string?trim}"
</#macro>

<#macro displayTag tagName>
<#assign tagRenderURL = renderResponse.createRenderURL()>
	${tagRenderURL.setParameter("mvcRenderCommandName", "/wiki/view_tagged_pages")}${tagRenderURL.setParameter("nodeId", entry.getNodeId()?string)}${tagRenderURL.setParameter("tag", tagName)}
	<span class="label label-lg text-uppercase">
		<span class="label-info label-item label-item-expand">
			<a href="${tagRenderURL}">${tagName}</a>
		</span>
	</span>
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

	<#if glyphicon?has_content >
		<span class="glyphicon glyphicon-${glyphicon}"> </span> 
	</#if>
	
	<#if tooltip == "true">
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}" data-toggle="tooltip" data-placement="top" title="${tooltipMsg}" data-animation="true">${title}</a>
	<#else>
		<a href="${portalURL}${pageFriendlyURL}/${wikiTitle}">${title}</a>
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

<#--   functions   -->

<#function getNormalizedWikiName string>
	<#return string?replace("á", "a")?replace("é","e")?replace("í","i")?replace("[ú|ü|ű]", "u", "r")?replace("[ó|ö|ő]", "o", "r")?replace("&", "<AMPERSAND>")?replace("'", "<APOSTROPHE>")?replace("@", "<AT>")?replace("]", "<CLOSE_BRACKET>,")?replace(")", "<CLOSE_PARENTHESIS>")?replace(":", "<COLON>")?replace(",", "<COMMA>")?replace("$", "<DOLLAR>")?replace("=", "<EQUAL>")?replace("!", "<EXCLAMATION>")?replace("[", "<OPEN_BRACKET>")?replace("(", "<OPEN_PARENTHESIS>")?replace("#", "<POUND>")?replace("?", "<QUESTION>")?replace(";", "<SEMICOLON>")?replace("/", "<SLASH>")?replace("*", "<STAR>")?replace("+","<PLUS>")?replace(" ","+")>
</#function>

<script type="text/javascript">
	$(document).ready(function () {
		
		/*Header buttons*/
		
		document.querySelector(".grow-wiki-body #editButton").addEventListener('click', function(event){ 
			window.location.href=<@displayEditLink/>;
		});
		
		document.querySelector(".grow-wiki-body #permalinkButton").addEventListener('click', function(event){ 
			window.location.href=<@displayFriendlyURL name=entry.getTitle() />;
		});
		
		document.querySelector(".grow-wiki-body #childrenButton").addEventListener('click', function(event){ 
		
		});
		
		document.querySelector(".grow-wiki-body #detailsButton").addEventListener('click', function(event){ 
			window.location.href=<@displayPageDetails />;
		});
		
		/*Footer buttons*/
		
		document.querySelector(".grow-wiki-body #outdateButton").addEventListener('click', function(event){ 

		});
		
		document.querySelector(".grow-wiki-body #likeButton").addEventListener('click', function(event){ 

		});
		
		document.querySelector(".grow-wiki-body #favouriteButton").addEventListener('click', function(event){ 

		});
		
	});
</script>