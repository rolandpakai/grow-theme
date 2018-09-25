<!DOCTYPE html>

<#include init />

<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">
	<head>

		<!-- Google Tag Manager -->
			<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
			new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
			j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
			'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
			})(window,document,'script','dataLayer','GTM-P4GB7RG');</script>
		<!-- End Google Tag Manager -->

		<title>${the_title} - ${company_name}</title>

		<meta content="initial-scale=1.0, width=device-width" name="viewport" />

		<@liferay_util["include"] page=top_head_include />

		<script type="text/javascript" src="${javascript_folder}/revolution/jquery.themepunch.tools.min.js"></script>
		<script type="text/javascript" src="${javascript_folder}/revolution/jquery.themepunch.revolution.min.js"></script>
		<script type="text/javascript" src="${javascript_folder}/owl/owl.carousel.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${javascript_folder}/prismjs/prism.css">
	</head>

	<body class="${css_class}">

		<!-- Google Tag Manager (noscript) -->
			<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-P4GB7RG"
			height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
		<!-- End Google Tag Manager (noscript) -->

		<@liferay_ui["quick-access"] contentId="#main-content" />

		<@liferay_util["include"] page=body_top_include />

		<@liferay.control_menu />

		<div id="wrapper">
			<header class="navbar navbar-default" id="banner" role="banner">
				<div class="container">
					<div class="navbar-header" id="heading">
						<a class="${logo_css_class}" href="${site_default_url}" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
							<img alt="${logo_description}" height="64" src="${site_logo}" />
						</a>

						<#if show_site_name>
							<span class="site-name" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
								${site_name}
							</span>
						</#if>

						<#if is_setup_complete>
							<button aria-controls="navigation" aria-expanded="false" class="collapsed navbar-toggle" data-target="#navigationCollapse" data-toggle="collapse" type="button">
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>

							<div class="pull-right user-personal-bar">
								<@liferay.user_personal_bar />
							</div>
						</#if>
					</div>

					<#include "${full_templates_path}/gsearch_navigation.ftl" />
				</div>
			</header>

			<section class="container-fluid-1824" id="content">
				<h1 class="hide-accessible">${the_title}</h1>

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

			<footer id="footer" role="contentinfo">
				<div class="container">
					<div class="row">
						<div class="footer-btm text-center">
							<span>
								<@liferay.language key="powered-by" /> <a href="http://www.liferay.com" rel="external">Liferay</a>
							</span>
						</div>
					</div>
				</div>
			</footer>
		</div>

		<@liferay_util["include"] page=body_bottom_include />
		<@liferay_util["include"] page=bottom_include />
		<script type="text/javascript" src="${javascript_folder}/prismjs/prism.js"></script>
	</body>
</html>
