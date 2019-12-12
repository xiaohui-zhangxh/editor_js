# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::TableBlock do
  let(:valid_data1) do
    {
      type: 'table',
      data: {
        content: [
          ['col1', 'col2'],
          ['row-2 col1', 'row-2 col2'],
          ['&lt;北京&gt;', '《成都》']
        ]
      }
    }
  end

  context 'with valid string' do
    let(:embed) { described_class.new(valid_data1.to_json) }

    it { expect(embed).to be_valid }
    it { expect(embed.render).to eq(%|<div class="editor_js--embed"><iframe src="http:/xxx" width="100%" height="300" frameborder="0" allowfullscreen="allowfullscreen"></iframe><span>Hello &lt;b&gt;Movie&lt;/b&gt;</span></div>|) }
    it { expect(embed.plain).to eq('col1, col2, row-2 col1, row-2 col2, <北京>, 《成都》') }
  end

  context 'with valid hash' do
    let(:embed) { described_class.new(valid_data1) }

    it { expect(embed).to be_valid }
  end
end
