<#assign serviceContext = staticUtil["com.liferay.portal.kernel.service.ServiceContextThreadLocal"].getServiceContext()> <#assign themeDisplay = serviceContext.getThemeDisplay()>
<#assign LayoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService")>

<div class="fullwidthbanner">
    <div class="tp-banner">
        <ul>
        <#list Section.getSiblings() as entries>
            <li data-transition="fade" data-slotamount="5" data-masterspeed="1000" data-title="${entries.Header.getData()}">
                <div class="caption title-2 sft" data-x="400" data-y="60" data-speed="1000" data-start="1000" data-easing="easeOutExpo"">
                <#assign layout = LayoutLocalService.getLayout(groupId, true, entries.LinkToPage.getData()?number)>
                <#assign tempLink = portalUtil.getLayoutFriendlyURL(layout, themeDisplay)>
                <#assign link = tempLink + "/-/wiki/Grow/" + entries.Header.getData()>
                    ${entries.Header.getData()}
                </div>
                <div class="caption text sfl" data-speed="1000" data-start="1800" data-easing="easeOutExpo">
                    <img style="width:100%; height:100%;" class="img-responsive center-block" src="${entries.Image.getData()}"/>
                </div>
                <h1 class="caption tp-resizeme tp-caption start" style="color: white;"  data-x="80" data-y="100" data-speed="400" data-start="1800" data-easing="Sine.easeOut">
                    ${entries.Description.getData()}
                </h1>
                <div class="caption sfb rev-buttons tp-resizeme" data-x="500" data-y="350" data-speed="500" data-start="2100" data-easing="Sine.easeeOut">
                    <a href="${link}" class="btn btn-primary btn-lg">Read more ....</a>
                </div>
            </li>
        </#list>
        </ul>
    </div>
</div>

<script type="text/javascript">
    $(function() {
        $('.tp-banner').revolution({
            delay: 6000,
            startwidth: 980,
            startheight: 480,
            hideThumbs: 10,
            navigationType: "bullet",
            navigationArrows: "solo",
            navigationStyle: "preview5"
        });
    });
</script>