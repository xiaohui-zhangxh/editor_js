# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::TableBlock do
  let(:valid_data1) do
    {
      type: 'table',
      data: {
        content: [
          ['col1', 'col2'],
          ['row-2 col1', 'row-2 col2'],
          ['&lt;hello&gt;', '<b>world</b>'],
          ['添加<b><i><mark class="cdx-marker"><code class="inline-code">第一个行内标签</code></mark></i></b>', '<code class="inline-code"><mark class="cdx-marker"><del class="cdx-strikeout"><b><i>行内标签</i></b></del></mark></code>']
        ]
      }
    }
  end

  context 'with valid data' do
    let(:table) { described_class.new(valid_data1) }

    it { expect(table).to be_valid }
    it { expect(table.render).to eq(%|<div class="editor_js--table"><table><tr><td>col1</td><td>col2</td></tr><tr><td>row-2 col1</td><td>row-2 col2</td></tr><tr><td>&lt;hello&gt;</td><td><b>world</b></td></tr><tr><td>添加<b><i><mark class="cdx-marker"><code class="inline-code">第一个行内标签</code></mark></i></b></td><td><code class="inline-code"><mark class="cdx-marker"><del class="cdx-strikeout"><b><i>行内标签</i></b></del></mark></code></td></tr></table></div>|) }
    it { expect(table.plain).to eq('col1, col2, row-2 col1, row-2 col2, <hello>, world, 添加第一个行内标签, 行内标签') }
  end

end
