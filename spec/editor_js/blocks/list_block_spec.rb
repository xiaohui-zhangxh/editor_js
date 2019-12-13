# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ListBlock do
  let(:valid_data1) do
    {
      type: 'list',
      data: {
        style: 'ordered',
        items: [
          'asdf&nbsp;. &lt;asdfa . asdfasdf&nbsp;',
          'module EditorJs'
        ]
      }
    }
  end

  context 'with valid string' do
    let(:embed) { described_class.new(valid_data1.to_json) }

    it { expect(embed).to be_valid }
    it { expect(embed.render).to eq(%|<ol class="editor_js--list"><li>asdf&nbsp;. &lt;asdfa . asdfasdf&nbsp;</li><li>module EditorJs</li></ol>|) }
    it { expect(embed.plain).to eq('asdf . <asdfa . asdfasdf , module EditorJs') }
  end

  context 'with valid hash' do
    let(:embed) { described_class.new(valid_data1) }

    it { expect(embed).to be_valid }
  end
end
