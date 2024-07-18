import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "init-video-player",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.m3u8_video_player_enabled) {
      withPluginApi("0.8.31", api => {
        api.onPageChange(() => {
          setTimeout(() => {
            const videoElements = document.querySelectorAll('.video-js');
            videoElements.forEach(element => {
              if (!element.player) {
                videojs(element);
              }
            });
          }, 200);
        });
      });
    }
  }
};
