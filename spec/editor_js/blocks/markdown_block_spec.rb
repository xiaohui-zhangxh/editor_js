# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::MarkedownBlock do
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
    it { expect(embed.render).to eq(%|<div class="editor_js--embed"><iframe src="http:/xxx" width="100%" height="300" frameborder="0" allowfullscreen="allowfullscreen"></iframe><span>Hello &lt;b&gt;Movie&lt;/b&gt;</span></div>|) }
    it { expect(embed.plain).to eq('Hello Movie') }
  end

  context 'with valid hash' do
    let(:embed) { described_class.new(valid_data1) }

    it { expect(embed).to be_valid }
  end
end
