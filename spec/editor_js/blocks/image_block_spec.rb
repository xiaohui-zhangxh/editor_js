# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ImageBlock do
  let(:valid_data1) do
    {
      type: 'image',
      data: {
        url: 'http://xxx/image.png',
        caption: 'this is a <b>caption</b> &lt;hello&gt; world',
        withBorder: false,
        withBackground: false,
        stretched: false
      }
    }
  end

  context 'with valid string' do
    let(:image) { described_class.new(valid_data1.to_json) }

    it { expect(image).to be_valid }

    it { expect(image.render).to eq(%|<div class="editor_js--image"><div class="editor_js--image__picture"><img src="http://xxx/image.png"></img></div><div class="editor_js--image__caption">this is a  &lt;hello&gt; world</div></div>|) }
    it { expect(image.plain).to eq('this is a  <hello> world') }
  end

  context 'with valid hash' do
    let(:image) { described_class.new(valid_data1) }

    it { expect(image).to be_valid }
  end
end
