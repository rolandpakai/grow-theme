<!DOCTYPE html>

<#include init />

<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">

<head>
	<#if google_tag_manager>
		<!-- Google Tag Manager -->
			<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
			new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
			j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
			'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
			})(window,document,'script','dataLayer','GTM-P4GB7RG');</script>
		<!-- End Google Tag Manager -->
	</#if>

	<title>${the_title} - ${company_name}</title>

	<meta content="initial-scale=1.0, width=device-width" name="viewport" />

	<@liferay_util["include"] page=top_head_include />
</head>

<body class="${css_class}">

	<#if google_tag_manager>
		<!-- Google Tag Manager (noscript) -->
			<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-P4GB7RG"
			height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
		<!-- End Google Tag Manager (noscript) -->
	</#if>

<@liferay_ui["quick-access"] contentId="#main-content" />

<@liferay_util["include"] page=body_top_include />

<@liferay.control_menu />

<div class="pt-0" id="wrapper">
	<#if show_header>
		<header id="banner">
			<div class="navbar navbar-classic py-2">
				<div class="container-fluid user-personal-bar">
					<div class="autofit-row d-flex align-items-center justify-content-around">
						<div>
							<a class="${logo_css_class} align-items-center d-md-inline-flex " href="${site_default_url}"">
								<img class="mr-2" height="60" src="${site_logo}" />

								<#if show_site_name>
									<h1 class="h2 mb-0">${site_name}</h1>
								</#if>
							</a>
						</div>
						
						<#assign preferences = freeMarkerPortletPreferences.getPreferences({"portletSetupPortletDecoratorId": "barebone", "destination": "/search"}) />
						
						<#if show_header_search>
							<div class="autofit-col autofit-col-expand">
								<div class="justify-content-md-end mr-4 navbar-form" role="search">
									<@liferay.search_bar default_preferences="${preferences}" />
								</div>	
							</div>
						</#if>
						
						<div class="navbar-expand-md navbar-light">
							<#include "${full_templates_path}/navigation.ftl" />
						</div>
						
						<div class="autofit-col">
							<@liferay.user_personal_bar />
						</div>
					</div>
				</div>
			</div>
		</header>
	</#if>

	<section class="${portal_content_css_class} container-fluid-1824" id="content">
		<h1 class="sr-only">${the_title}</h1>

		<#if selectable>
			<@liferay_util["include"] page=content_include />
		<#else>
			${portletDisplay.recycle()}

			${portletDisplay.setTitle(the_title)}

			<@liferay_theme["wrap-portlet"] page="portlet.ftl">
				<@liferay_util["include"] page=content_include />
			</@>
		</#if>
	</section>

	<#if show_footer>
		<footer id="footer" role="contentinfo">
			<div class="container">
				<div class="row">
					<div class="col-md-12 text-center text-dark">
						<@liferay.language key="powered-by" />

						<a href="http://www.liferay.com" rel="external">Liferay</a>
					</div>
				</div>
			</div>
		</footer>
	</#if>
</div>

<@liferay_util["include"] page=body_bottom_include />

<@liferay_util["include"] page=bottom_include />

<script type="text/javascript" src="${javascript_folder}/prismjs/prism.js"></script>

</body>

</html>