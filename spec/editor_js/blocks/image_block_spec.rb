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

    it { expect(image.render).to eq(%|<div class="editor_js--image"><img src="http://xxx/image.png"></img><span>this is a  &lt;hello&gt; world</div>|) }
    it { expect(image.plain).to eq('this is a  <hello> world') }
  end

  context 'with valid hash' do
    let(:image) { described_class.new(valid_data1) }

    it { expect(image).to be_valid }
  end
end
