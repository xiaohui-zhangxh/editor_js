# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ChecklistBlock do
  let(:valid_data1) do
    {
      type: 'checklist',
      data: {
        items: [
          { text: 'item 1 &lt;b&gt;bold&lt;/b&gt;', checked: true },
          { text: 'item <b>2</b>', checked: false },
          { text: 'item 3', checked: false }
        ]
      }
    }
  end

  context 'with valid string' do
    let(:checklist) { described_class.new(valid_data1.to_json) }

    it { expect(checklist).to be_valid }
    it { expect(checklist.render).to eq('<div class="editor_js--checklist"><input type="checkbox" disabled="disabled" checked="checked">item 1 &lt;b&gt;bold&lt;/b&gt;</input><input type="checkbox" disabled="disabled">item 2</input><input type="checkbox" disabled="disabled">item 3</input></div>') }
    it { expect(checklist.plain).to eq('item 1 <b>bold</b>, item 2, item 3') }
  end

  context 'with valid hash' do
    let(:checklist) { described_class.new(valid_data1) }

    it { expect(checklist).to be_valid }
  end
end
