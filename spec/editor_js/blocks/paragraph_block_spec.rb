# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ParagraphBlock do
  let(:valid_data1) do
    {
      type: 'paragraph',
      data: {
        'text': "adsf&lt;div class='mr-1'&gt;&lt;/div&gt;<b>nihao</b>"
      }
    }
  end

  context 'with valid string' do
    let(:paragraph) { described_class.new(valid_data1.to_json) }

    it { expect(paragraph).to be_valid }
    it { expect(paragraph.render).to eq(%|<p class=\"editor_js--paragraph\">adsf&lt;div class='mr-1'&gt;&lt;/div&gt;<b>nihao</b></p>|) }
    it { expect(paragraph.plain).to eq("adsf<div class='mr-1'></div>nihao") }
  end

  context 'with valid hash' do
    let(:paragraph) { described_class.new(valid_data1) }

    it { expect(paragraph).to be_valid }
  end
end
