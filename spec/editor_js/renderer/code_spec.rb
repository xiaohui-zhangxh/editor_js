# frozen_string_literal: true

require 'action_controller'
require 'active_support/all'

RSpec.describe EditorJS::Renderer::Code do
  let(:tag_helper) { ActionController::Base.helpers }

  it do
    renderer = described_class.new
    text = <<~TEXT.strip
      function hello{
        console.log('hello world')
      }
    TEXT
    block = Struct.new(:data).new(code: text)
    html = <<~HTML.strip
    <code class="block__code">function hello{
      console.log(&#39;hello world&#39;)
    }</code>
    HTML
    expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    expect(renderer.render_text(block)).to eq text
  end

  it do
    renderer = described_class.new tag_name: 'div'
    text = <<~TEXT.strip
      function hello{
        console.log('hello world')
      }
    TEXT
    block = Struct.new(:data).new(code: text)
    html = <<~HTML.strip
    <div class="block__code">function hello{
      console.log(&#39;hello world&#39;)
    }</div>
    HTML
    expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    expect(renderer.render_text(block)).to eq text
  end

  it do
    renderer = described_class.new class_name: 'block__my-code'
    text = <<~TEXT.strip
      function hello{
        console.log('hello world')
      }
    TEXT
    block = Struct.new(:data).new(code: text)
    html = <<~HTML.strip
    <code class="block__my-code">function hello{
      console.log(&#39;hello world&#39;)
    }</code>
    HTML
    expect(renderer.render_html(block, tag_helper: tag_helper)).to eq html
    expect(renderer.render_text(block)).to eq text
  end
end
