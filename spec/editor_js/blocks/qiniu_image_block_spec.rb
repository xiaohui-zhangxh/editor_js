# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QiniuImageBlock do
  let(:valid_data1) do
    {
      type: 'qiniu_image',
      data: {
        url: 'http://xxx/image.png',
        caption: '七牛<b>图片</b>2&lt;/div&gt;',
        withBorder: true,
        withBackground: false,
        stretched: false
      }
    }
  end

  context 'with valid string' do
    let(:qiniu_image) { described_class.new(valid_data1.to_json) }

    it { expect(qiniu_image).to be_valid }
    it { expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><img src="http://xxx/image.png"></img><span>七牛图片2&lt;/div&gt;</span></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛图片2</div>') }
  end

  context 'with valid hash' do
    let(:qiniu_image) { described_class.new(valid_data1) }

    it { expect(qiniu_image).to be_valid }
  end
end
