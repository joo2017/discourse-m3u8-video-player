# name: discourse-m3u8-video-player
# about: 添加使用 Video.js 播放 m3u8 视频的支持
# version: 0.1
# authors: 您的名字
# url: https://github.com/您的用户名/discourse-m3u8-video-player

enabled_site_setting :m3u8_video_player_enabled

register_asset 'stylesheets/m3u8-video-player.scss'

after_initialize do
  if SiteSetting.m3u8_video_player_enabled
    # 添加 Video.js CDN 链接
    register_html_builder('server:before-head-close') do
      "<link href='https://vjs.zencdn.net/7.20.3/video-js.min.css' rel='stylesheet'>"
    end

    register_html_builder('server:after-head-close') do
      "<script src='https://vjs.zencdn.net/7.20.3/video.min.js'></script>"
    end

    Onebox::Engine::VideoOnebox.class_eval do
      matches_regexp(%r{^(https?:)?//.*\.(mov|mp4|webm|ogv|m3u8)(\?.*)?$}i)

      def to_html
        if @url.match(%r{\.m3u8$})
          random_id = "video-#{SecureRandom.hex(8)}"
          <<-HTML
            <div class="onebox video-onebox videoWrap">
              <video id='#{random_id}' class="video-js vjs-default-skin vjs-16-9" controls preload="auto" width="100%" data-setup='{"fluid": true}'>
                <source src="#{@url}" type="application/x-mpegURL">
              </video>
            </div>
          HTML
        else
          # 原有的非 m3u8 文件处理代码
          escaped_url = ::Onebox::Helpers.normalize_url_for_output(@url)
          <<-HTML
            <div class="onebox video-onebox">
              <video width='100%' height='100%' controls #{@options[:disable_media_download_controls] ? 'controlslist="nodownload"' : ""}>
                <source src='#{escaped_url}'>
                <a href='#{escaped_url}'>#{@url}</a>
              </video>
            </div>
          HTML
        end
      end
    end
  end
end
