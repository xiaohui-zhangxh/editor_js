# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ListBlock do
  let(:valid_data1) do
    {
      type: 'list',
      data: {
        style: 'ordered',
        items: [
          'item <b>hacker</b> &lt;1&gt;',
          'item &lt;2&gt;',
          'item 3'
        ]
      }
    }
  end

  context 'with valid string' do
    let(:list) { described_class.new(valid_data1.to_json) }

    it { expect(list).to be_valid }
    it { expect(list.render).to eq(%|<ol class="editor_js--list"><li>item  &lt;1&gt;</li><li>item &lt;2&gt;</li><li>item 3</li></ol>|) }
    it { expect(list.plain).to eq('item <1>, item <2>, item 3') }
  end

  context 'with valid hash' do
    let(:list) { described_class.new(valid_data1) }

    it { expect(list).to be_valid }
  end
end
