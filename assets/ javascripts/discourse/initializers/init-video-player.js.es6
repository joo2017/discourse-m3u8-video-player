import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "init-video-player",
  initialize() {
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
};
