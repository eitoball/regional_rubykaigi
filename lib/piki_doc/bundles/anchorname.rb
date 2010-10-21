### 使い方
### 以下の順番で引数を渡してください。
### 1.アンカーネーム(※必須)、2.要素となるテキスト or 画像のパス、3.要素が画像の場合、ALT(画像の説明)
### 例　{{anchorname('map', '/images/map.png', '地図')}}

module PikiDoc
  module Bundles
    class Anchorname
      include PluginAdapter

      def initialized
      end

      def inline_plugin(src, suffix)
        generate_anchor(src, 'span', suffix)
      end

      def block_plugin(src, suffix)
        generate_anchor(src, 'div', suffix)
      end

      private

      def generate_anchor(src, type, suffix)
        (name, element, alt) = src.scan(/'(.*?)'/).flatten
        if (name == nil) || (%r(\A\s*\Z) =~ name)
          plugin_dom(type, <<-HTML)
<br#{suffix}<strong>【プラグインエラー： anchorname】</strong> 2つの値を以下の順で正しく設定してください<br#{suffix}
1.アンカーネーム(※必須)、2.要素となるテキスト or 画像のパス、3.要素が画像の場合、ALT(画像の説明)<br#{suffix}
例　{{anchorname('map', '/images/map.png', '地図')}}<br#{suffix}
          HTML
        else
          if (element != nil) && (%r(.jpg|.jpeg|.png|.gif) =~ File.extname(element).downcase)
            plugin_dom(type, <<-HTML)
<a name="#{name}"><img src="#{element}" alt="#{alt||' '}"#{suffix}</a>
            HTML
          else
            plugin_dom(type, <<-HTML)
<a name="#{name}">#{element||' '}</a>
            HTML
          end
        end
      end

    end
  end
end
