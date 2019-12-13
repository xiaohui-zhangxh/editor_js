# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::TableBlock do
  let(:valid_data1) do
    {
      type: 'table',
      data: {
        content: [
          ['col1', 'col2'],
          ['row-2 col1', 'row-2 col2'],
          ['&lt;hello&gt;', '<b>world</b>']
        ]
      }
    }
  end

  context 'with valid string' do
    let(:table) { described_class.new(valid_data1.to_json) }

    it { expect(table).to be_valid }
    it { expect(table.render).to eq(%|<div class="editor_js--table"><table><tr><td>col1</td><td>col2</td></tr><tr><td>row-2 col1</td><td>row-2 col2</td></tr><tr><td>&lt;hello&gt;</td><td></td></tr></table></div>|) }
    it { expect(table.plain).to eq('col1, col2, row-2 col1, row-2 col2, <hello>, ') }
  end

  context 'with valid hash' do
    let(:table) { described_class.new(valid_data1) }

    it { expect(table).to be_valid }
  end
end
