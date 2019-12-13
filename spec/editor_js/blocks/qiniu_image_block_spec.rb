# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QiniuImageBlock do
  let(:valid_data1) do
    {
      type: 'qiniu_image',
      data: {
        url: 'http://assets.wedxt.com/1576156689709-%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-10-15%2021.34.57.png',
        caption: '七牛图片2&lt;/div&gt;',
        withBorder: true,
        withBackground: false,
        stretched: false
      }
    }
  end

  context 'with valid string' do
    let(:qiniu_image) { described_class.new(valid_data1.to_json) }

    it { expect(qiniu_image).to be_valid }
    it { expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><div class="simple-image__picture simple-image__picture--with-border"><img src="http://assets.wedxt.com/1576156689709-%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-10-15%2021.34.57.png"></img></div><div class="simple-image__caption">七牛图片2&lt;/div&gt;</div></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛图片2</div>') }
  end

  context 'with valid hash' do
    let(:qiniu_image) { described_class.new(valid_data1) }

    it { expect(qiniu_image).to be_valid }
  end
end
