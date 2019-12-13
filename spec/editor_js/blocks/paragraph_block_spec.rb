# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ParagraphBlock do
  let(:valid_data1) do
    {
      type: 'paragraph',
      data: {
        'text': "this is a paragraph &lt;div class='mr-1'&gt;hello&lt;/div&gt; <b>world</b>"
      }
    }
  end

  context 'with valid string' do
    let(:paragraph) { described_class.new(valid_data1.to_json) }

    it { expect(paragraph).to be_valid }
    it { expect(paragraph.render).to eq(%|<div class="editor_js--paragraph">this is a paragraph &lt;div class='mr-1'&gt;hello&lt;/div&gt; <b>world</b></div>|) }
    it { expect(paragraph.plain).to eq("this is a paragraph <div class='mr-1'>hello</div> world") }
  end

  context 'with valid hash' do
    let(:paragraph) { described_class.new(valid_data1) }

    it { expect(paragraph).to be_valid }
  end
end
