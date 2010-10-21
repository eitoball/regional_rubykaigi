### 使い方
### 以下の順番で引数を渡してください。
### 1.画像へのパス(※必須)、2.リンク先(※必須)、 3.ALT(画像の説明)、 4.画像の幅、 5.画像の高さ、6.ターゲット(ページの開き方)
### 例　{{imagelink('/images/map.png', 'http://exapmle.com', '地図', '240', '180', '_blank')}}

module PikiDoc
  module Bundles
    class Imagelink
      include PluginAdapter

      def initialized
      end

      def inline_plugin(src, suffix)
        generate_link(src, 'span', suffix)
      end

      def block_plugin(src, suffix)
        generate_link(src, 'div', suffix)
      end

      private

      def generate_link(src, type, suffix)
        (imagepath, url, alt, width, height, target) = src.scan(/'(.*?)'/).flatten
        if [imagepath,url].any?{|arg| (arg == nil) || %r(\A\s*\Z) =~ arg}
          plugin_dom(type, <<-HTML)
<br#{suffix}<strong>【プラグインエラー： imagelink】</strong> 5つの値を以下の順で正しく設定してください<br#{suffix}
1.画像へのパス(※必須)、2.リンク先(※必須)、 3.ALT(画像の説明)、 4.画像の幅、 5.画像の高さ、6.ターゲット(ページの開き方)<br#{suffix}
例　{{imagelink('/images/map.png', 'http://exapmle.com', '地図', '240', '180', '_blank')}}<br#{suffix}
          HTML
        else
          plugin_dom(type, <<-HTML)
<a href="#{url}"><img src="#{imagepath}" alt="#{alt||' '}"#{width ? ' width="'+width+'"' : nil}#{height ? ' height="'+height+'"' : nil}#{target ? ' target="'+target+'"' : nil}#{suffix}</a>
          HTML
        end
      end

    end
  end
end
