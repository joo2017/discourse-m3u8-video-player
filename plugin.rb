# name: discourse-m3u8-video-player
# about: 添加使用 Video.js 播放 m3u8 视频的支持
# version: 0.1
# authors: 您的名字
# url: https://github.com/您的用户名/discourse-m3u8-video-player

enabled_site_setting :m3u8_video_player_enabled

register_asset 'stylesheets/m3u8-video-player.scss'

after_initialize do
  if SiteSetting.m3u8_video_player_enabled
    # Video.js CDN 链接现在移动到客户端初始化器中

    on(:before_head_close) do |controller|
      controller.helpers.tag.link(href: "https://vjs.zencdn.net/7.20.3/video-js.min.css", rel: "stylesheet")
    end

    on(:after_head_close) do |controller|
      controller.helpers.tag.script(src: "https://vjs.zencdn.net/7.20.3/video.min.js")
    end

    module ::DiscourseMHLSPlayer
      class Engine < ::Rails::Engine
        engine_name "discourse_m3u8_player"
        isolate_namespace DiscourseMHLSPlayer
      end
    end

    require_dependency "onebox/engine/video_onebox"

    class ::Onebox::Engine::VideoOnebox
      def to_html
        if @url.match?(%r{\.m3u8(\?.*)?$}i)
          <<-HTML
            <div class="onebox video-onebox">
              <video class="video-js vjs-default-skin vjs-big-play-centered" controls preload="auto" width="100%" height="100%" data-setup='{"fluid": true}'>
                <source src="#{@url}" type="application/x-mpegURL">
              </video>
            </div>
          HTML
        else
          super
        end
      end
    end
  end
end
