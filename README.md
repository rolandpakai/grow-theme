# GROW Theme

A Liferay theme for GROW based on _styled theme.

## Instructions

After you call npm init in this project please add a "liferay-theme.json" with the following content:
```
{
  "LiferayTheme": {
    "appServerPath": "#liferay_path\\tomcat-8.0.32",
    "deployPath": "#liferay_path\\deploy",
    "url": "#liferay_url",
    "appServerPathPlugin": "#theme_path\\grow-theme\\.web_bundle_build",
    "deployed": true,
    "pluginName": "grow-theme"
  }
} 
```
## Release Notes

### 1.6.1

- [OWXP-226](https://issues.liferay.com/browse/OWXP-226) – Bold texts doesn't work with new grow Theme
- [OWXP-229](https://issues.liferay.com/browse/OWXP-229) – Add the permalink to page titles and a function button
- [OWXP-236](https://issues.liferay.com/browse/OWXP-236) – Add tags to wiki pages
- [OWXP-237](https://issues.liferay.com/browse/OWXP-237) – Create custom GROW favicon
- [OWXP-238](https://issues.liferay.com/browse/OWXP-238) – Customize the HTML title of Grow
