<#if entries?has_content>  
    <#assign currentLayoutId = themeDisplay.getLayout().getLayoutId()> 

	<nav>
		<ul class="nav navbar-nav">
			<#list entries as navigationEntry>
				<#if currentLayoutId == navigationEntry.getLayoutId()>
					<li role="presentation" class="dropdown active">
						<a href="<@getURLWithWiki name=navigationEntry.getName()/>">${navigationEntry.getName()} </a>
					</li>
				<#else>
					<li role="presentation" class="dropdown">
						<a href="<@getURLWithWiki name=navigationEntry.getName()/>">${navigationEntry.getName()} </a>
					</li>
				</#if> 
			</#list> 
		</ul>
	</nav>
</#if>

<#macro getURLWithWiki name >
	<#assign portalURL = portal.getPortalURL(request)>
	<#assign privateFriendlyURL = prefsPropsUtil.getString(companyId, "layout.friendly.url.private.group.servlet.mapping")> 
	<#assign siteFriendlyURL = themeDisplay.getSiteGroup().getFriendlyURL()>

	<#if (name?lower_case == "people") || (name?lower_case == "learn") || (name?lower_case == "excellence") || (name?lower_case == "share")>
		${portalURL}${privateFriendlyURL}${siteFriendlyURL}/${name}/-/wiki/Grow/${name?replace(" ", "+")}
	<#else>
		${portalURL}${privateFriendlyURL}${siteFriendlyURL}/${name?replace(" ", "+")}
	</#if>
</#macro>