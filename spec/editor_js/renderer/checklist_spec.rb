# frozen_string_literal: true

require 'action_controller'
require 'active_support/all'

RSpec.describe EditorJS::Renderer::Checklist do
  let(:html_decoder) do
    EditorJS::HTMLDecoder.new
  end
  let(:tag_helper) { ActionController::Base.helpers }
  let(:text_sanitizer) { EditorJS::TextSanitizer.new }
  let(:renderer) { described_class.new html_sanitizer: html_sanitizer, html_decoder: html_decoder, text_sanitizer: text_sanitizer }

  it '.default_options' do
    expect(described_class.default_options).to match(class_name: 'block__checklist',
                                                     tag_name: 'ul',
                                                     item_tag_name: 'li',
                                                     checked_class_name: 'checklist--checked',
                                                     delimiter: ', ')
  end

  it '.default_html_sanitizer_options' do
    expect(described_class.default_html_sanitizer_options).to match(
      elements: %w[b i u del a mark code],
      attributes: {
        'u' => ['class'],
        'del' => ['class'],
        'a' => ['href'],
        'mark' => ['class'],
        'code' => ['class']
      }
    )
  end

  describe 'allow <i>' do
    let(:block) do
      Struct.new(:data).new(items: [
                              { text: 'this is a normal item', checked: true },
                              { text: 'this item includes unsafe script <script>hacker code</script>', checked: true },
                              { text: 'this item includes unsafe html <a href="/admin">admin</a>', checked: false },
                              { text: 'this item includes safe html <i class="fa fa-setting">hello</i>', checked: false }
                            ])
    end
    let(:html_sanitizer) { EditorJS::HTMLSanitizer.new(elements: ['i']) }
    it do
      html = <<~HTML.strip
        <ul class="block__checklist">
        <li class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this is a normal item</li>
        <li class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this item includes unsafe script</li>
        <li><input type="checkbox" disabled="disabled"></input> this item includes unsafe html admin</li>
        <li><input type="checkbox" disabled="disabled"></input> this item includes safe html <i>hello</i></li>
        </ul>
      HTML
      expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    end
    it do
      text = <<~TEXT.strip.lines.map(&:strip).join(', ')
        this is a normal item
        this item includes unsafe script
        this item includes unsafe html admin
        this item includes safe html hello
      TEXT
      expect(renderer.render_text(block)).to eq text
    end
  end

  describe 'allow <i class="xx">' do
    let(:block) do
      Struct.new(:data).new(items: [
                              { text: 'this is a normal item', checked: true },
                              { text: 'this item includes unsafe script <script>hacker code</script>', checked: true },
                              { text: 'this item includes unsafe html <a href="/admin">admin</a>', checked: false },
                              { text: 'this item includes safe html <i class="fa fa-setting">hello</i>', checked: false }
                            ])
    end
    let(:html_sanitizer) { EditorJS::HTMLSanitizer.new(elements: ['i'], attributes: { 'i' => ['class'] }) }
    it do
      html = <<~HTML.strip
        <ul class="block__checklist">
        <li class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this is a normal item</li>
        <li class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this item includes unsafe script</li>
        <li><input type="checkbox" disabled="disabled"></input> this item includes unsafe html admin</li>
        <li><input type="checkbox" disabled="disabled"></input> this item includes safe html <i class="fa fa-setting">hello</i></li>
        </ul>
      HTML
      expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    end
    it do
      text = <<~TEXT.strip.lines.map(&:strip).join(', ')
        this is a normal item
        this item includes unsafe script
        this item includes unsafe html admin
        this item includes safe html hello
      TEXT
      expect(renderer.render_text(block)).to eq text
    end
  end

  describe 'div > span' do
    let(:block) do
      Struct.new(:data).new(items: [
                              { text: 'this is a normal item', checked: true },
                              { text: 'this item includes unsafe script <script>hacker code</script>', checked: true },
                              { text: 'this item includes unsafe html <a href="/admin">admin</a>', checked: false },
                              { text: 'this item includes safe html <i class="fa fa-setting">hello</i>', checked: false }
                            ])
    end
    let(:html_sanitizer) { EditorJS::HTMLSanitizer.new(elements: ['i'], attributes: { 'i' => ['class'] }) }
    let(:renderer) do
      described_class.new html_sanitizer: html_sanitizer, html_decoder: html_decoder,
                          text_sanitizer: text_sanitizer, tag_name: 'div', item_tag_name: 'span'
    end
    it do
      html = <<~HTML.strip
        <div class="block__checklist">
        <span class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this is a normal item</span>
        <span class="checklist--checked"><input type="checkbox" disabled="disabled" checked="checked"></input> this item includes unsafe script</span>
        <span><input type="checkbox" disabled="disabled"></input> this item includes unsafe html admin</span>
        <span><input type="checkbox" disabled="disabled"></input> this item includes safe html <i class="fa fa-setting">hello</i></span>
        </div>
      HTML
      expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    end
    it do
      text = <<~TEXT.strip.lines.map(&:strip).join(', ')
        this is a normal item
        this item includes unsafe script
        this item includes unsafe html admin
        this item includes safe html hello
      TEXT
      expect(renderer.render_text(block)).to eq text
    end
  end
end
