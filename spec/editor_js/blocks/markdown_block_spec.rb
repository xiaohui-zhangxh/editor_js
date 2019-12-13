# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::MarkdownBlock do
  let(:valid_data1) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
          ```javascript
            function hello() {
              console.log('hello')
            }
          ```
          ```html
            <h1>This is header</h1>
          ```
          plain text
        MARKDOWN
      }
    }
  end

  context 'with valid string' do
    let(:markdown) { described_class.new(valid_data1.to_json) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
        <div class="editor_js--markdown"><div class="CodeRay">
          <div class="code"><pre>  <span class="keyword">function</span> <span class="function">hello</span>() {
            console.log(<span class="string"><span class="delimiter">'</span><span class="content">hello</span><span class="delimiter">'</span></span>)
          }
        </pre></div>
        </div>
        <div class="CodeRay">
          <div class="code"><pre>  <span class="tag">&lt;h1&gt;</span>This is header<span class="tag">&lt;/h1&gt;</span>
        </pre></div>
        </div>

        <p>plain text</p>
        </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data1[:data][:text].strip) }
  end

  context 'with valid hash' do
    let(:markdown) { described_class.new(valid_data1) }

    it { expect(markdown).to be_valid }
  end
end
