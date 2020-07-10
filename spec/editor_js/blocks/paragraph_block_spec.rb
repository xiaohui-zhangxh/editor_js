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

  let(:valid_data2) do
    {
      type: 'paragraph',
      data: {
        'text': "第一短话需要居中",
        'alignment': 'align-center'
      }
    }
  end

  context 'with valid data' do
    let(:paragraph) { described_class.new(valid_data1) }

    it { expect(paragraph).to be_valid }
    it { expect(paragraph.render).to eq(%|<div class="editor_js--paragraph">this is a paragraph &lt;div class='mr-1'&gt;hello&lt;/div&gt; <b>world</b></div>|) }
    it { expect(paragraph.plain).to eq("this is a paragraph <div class='mr-1'>hello</div> world") }
  end

  context 'with valid data' do
    let(:paragraph) { described_class.new(valid_data2) }

    it { expect(paragraph).to be_valid }
    it { expect(paragraph.render).to eq(%|<div class="editor_js--paragraph editor_js--paragraph__align-center">第一短话需要居中</div>|) }
    it { expect(paragraph.plain).to eq("第一短话需要居中") }
  end
end
