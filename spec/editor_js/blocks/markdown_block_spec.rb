# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::MarkdownBlock do
  let(:valid_data1) do
    {
      type: 'markdown',
      data: {
        text: '```javascript\nfunction a () {\n}\n```\n\nasdf \nasdf\nsd999999\n<htnml>\nadsf '
      }
    }
  end

  context 'with valid string' do
    let(:embed) { described_class.new(valid_data1.to_json) }

    it { expect(embed).to be_valid }
    it { expect(embed.render).to eq(%|<div class=\"editor_js--markdown markdown-block markdown-body\"><p><code>javascript\\nfunction a () {\\n}\\n</code>\\n\\nasdf \\nasdf\\nsd999999\\n&lt;htnml&gt;\\nadsf </p>\n</div>|) }
    it { expect(embed.plain).to eq('```javascript\\nfunction a () {\\n}\\n```\\n\\nasdf \\nasdf\\nsd999999\\n<htnml>\\nadsf') }
  end

  context 'with valid hash' do
    let(:embed) { described_class.new(valid_data1) }

    it { expect(embed).to be_valid }
  end
end
