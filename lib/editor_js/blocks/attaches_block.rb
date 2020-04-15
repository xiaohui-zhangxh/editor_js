# frozen_string_literal: true

module EditorJs
  module Blocks
    class AttachesBlock < Base
      include ActiveSupport::NumberHelper

      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            file:
              type: object
              additionalProperties: false
              properties:
                url:
                  type: string
                name:
                  type: string
                type:
                  type: string
                size:
                  type: number
            title:
              type: string
          required:
          - file
        YAML
      end

      EXTENSIONS = {
        'doc' => '#3e74da',
        'docx' => '#3e74da',
        'odt' => '#3e74da',
        'pdf' => '#d47373',
        'rtf' => '#656ecd',
        'tex' => '#5a5a5b',
        'txt' => '#5a5a5b',
        'pptx' => '#e07066',
        'ppt' => '#e07066',
        'mp3' => '#eab456',
        'mp4' => '#f676a6',
        'xls' => '#3f9e64',
        'html' => '#2988f0',
        'htm' => '#2988f0',
        'png' => '#f676a6',
        'jpg' => '#f67676',
        'jpeg' => '#f67676',
        'gif' => '#f6af76',
        'zip' => '#4f566f',
        'rar' => '#4f566f',
        'exe' => '#e26f6f',
        'svg' => '#bf5252',
        'key' => '#e07066',
        'sketch' => '#df821c',
        'ai' => '#df821c',
        'psd' => '#388ae5',
        'dmg' => '#e26f6f',
        'json' => '#2988f0',
        'csv' => '#3f9e64'
      }

      ICONS = {
        file_icon: '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="40"><path d="M17 0l15 14V3v34a3 3 0 0 1-3 3H3a3 3 0 0 1-3-3V3a3 3 0 0 1 3-3h20-6zm0 2H3a1 1 0 0 0-1 1v34a1 1 0 0 0 1 1h26a1 1 0 0 0 1-1V14H17V2zm2 10h7.926L19 4.602V12z"></path></svg>',
        custom_file_icon: '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="40"><g fill="#A8ACB8" fill-rule="evenodd"><path fill-rule="nonzero" d="M17 0l15 14V3v34a3 3 0 0 1-3 3H3a3 3 0 0 1-3-3V3a3 3 0 0 1 3-3h20-6zm0 2H3a1 1 0 0 0-1 1v34a1 1 0 0 0 1 1h26a1 1 0 0 0 1-1V14H17V2zm2 10h7.926L19 4.602V12z"></path><path d="M7 22h18v2H7zm0 4h18v2H7zm0 4h18v2H7z"></path></g></svg>',
        download_icon: '<svg xmlns="http://www.w3.org/2000/svg" width="17pt" height="17pt" viewBox="0 0 17 17"><path d="M9.457 8.945V2.848A.959.959 0 0 0 8.5 1.89a.959.959 0 0 0-.957.957v6.097L4.488 5.891a.952.952 0 0 0-1.351 0 .952.952 0 0 0 0 1.351l4.687 4.688a.955.955 0 0 0 1.352 0l4.687-4.688a.952.952 0 0 0 0-1.351.952.952 0 0 0-1.351 0zM3.59 14.937h9.82a.953.953 0 0 0 .953-.957.952.952 0 0 0-.953-.953H3.59a.952.952 0 0 0-.953.953c0 .532.425.957.953.957zm0 0" fill-rule="evenodd"></path></svg>'
      }

      def render(_options = {})
        file_info = data['file']
        title = data['title']
        extension = file_info['name']&.split('.')&.last
        extension = '' unless EXTENSIONS.key?(extension)

        content_tag :div, class: css_name do
          html_str = content_tag :div, class: "#{css_name}__file-icon", data: {extension: extension}, style: "color: #{EXTENSIONS[extension]};" do
            (EXTENSIONS[extension] ? ICONS[:file_icon] : ICONS[:custom_file_icon]).html_safe
          end

          html_str += content_tag :div, class: "#{css_name}__file-info" do
            [
              content_tag(:div, title, class: "#{css_name}__title"),
              content_tag(:div, number_to_human_size(file_info['size']), class: "#{css_name}__size")
            ].join().html_safe
          end

          html_str += content_tag :a, class: "#{css_name}__download-button", href: file_info['url'], target: '_blank', rel: 'nofollow noindex noreferrer' do
            ICONS[:download_icon].html_safe
          end
          html_str.html_safe
        end
      end

      def sanitize!
        data['title'] = Sanitize.fragment(data['title'], remove_contents: true).strip
        file_info = data['file'] || {}
        file_info.each do |key, val|
          break if key == 'size'

          file_info[key] = Sanitize.fragment(val, remove_contents: true).strip
        end
        data['file'] = file_info
      end

      def plain
        decode_html data['title'].strip
      end
    end
  end
end
