# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ChecklistBlock do
  let(:valid_data1) do
    {
      type: 'checklist',
      data: {
        items: [
          { text: 'item 1 &lt;b&gt;bold&lt;/b&gt;', checked: true },
          { text: 'item <b>2</b>', checked: false },
          { text: 'item 3 <strong>bobo<strong>', checked: false }
        ]
      }
    }
  end

  context 'with valid data' do
    let(:checklist) { described_class.new(valid_data1) }

    it { expect(checklist).to be_valid }
    it { expect(checklist.render).to eq('<div class="editor_js--checklist"><div class="editor_js--checklist__warrper"><input type="checkbox" disabled="disabled" checked="checked"></input><label>item 1 &amp;lt;b&amp;gt;bold&amp;lt;/b&amp;gt;</label></div><div class="editor_js--checklist__warrper"><input type="checkbox" disabled="disabled"></input><label>item</label></div><div class="editor_js--checklist__warrper"><input type="checkbox" disabled="disabled"></input><label>item 3</label></div></div>') }
    it { expect(checklist.plain).to eq('item 1 <b>bold</b>, item, item 3') }
  end
end
