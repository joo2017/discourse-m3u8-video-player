import { withPluginApi } from "discourse/lib/plugin-api";
import { loadScript, loadCSS } from "discourse/lib/load-script";

export default {
  name: "init-video-player",
  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    if (siteSettings.m3u8_video_player_enabled) {
      withPluginApi("0.8.31", api => {
        api.onPageChange(() => {
          const videoElements = document.querySelectorAll('video.video-js');
          if (videoElements.length > 0 && typeof videojs === 'undefined') {
            loadCSS("https://vjs.zencdn.net/7.20.3/video-js.min.css").then(() => {
              loadScript("https://vjs.zencdn.net/7.20.3/video.min.js").then(() => {
                videoElements.forEach(element => {
                  if (!element.player) {
                    videojs(element);
                  }
                });
              });
            });
          }
        });
      });
    }
  }
};
