# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QiniuImageBlock do
  let(:valid_data1) do
    {
      type: 'qiniu_image',
      data: {
        url: 'http://xxx/image.png',
        caption: '七牛<b>图片</b>2&lt;/div&gt;<small>text code</small>',
        withBorder: true,
        withBackground: false,
        stretched: false
      }
    }
  end

  let(:valid_data2) do
    {
      type: 'qiniu_image',
      data: {
        url: 'http://xxx/image2.png',
        caption: '七牛<b>图片</b>2&lt;/div&gt;<small>text code2</small>',
        withBorder: true,
        withBackground: true,
        stretched: false
      }
    }
  end

  let(:valid_data3) do
    {
      type: 'qiniu_image',
      data: {
        url: 'http://xxx/image3.png',
        caption: '七牛<b>图片</b>2&lt;/div&gt;<small>text code3</small>',
        withBorder: false,
        withBackground: false,
        stretched: true
      }
    }
  end

  let(:valid_data4) do
    {
      type: 'qiniuImage',
      data: {
        url: 'http://xxx/f.image4.png',
        caption: '七牛<b>图片</b>4&lt;/div&gt;<small>text code3</small>',
        withBorder: true,
        withBackground: true,
        stretched: true
      }
    }
  end

  context 'with valid data' do
    let(:qiniu_image) { described_class.new(valid_data1) }

    it { expect(qiniu_image).to be_valid }
    it { expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><div class="editor_js--qiniu_image__picture editor_js--qiniu_image__picture--with-border"><img src="http://xxx/image.png"></img></div><div class="editor_js--qiniu_image__caption">七牛2&lt;/div&gt;</div></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛2</div>') }
  end

  context 'with valid data; image style withBorder withBackground' do
    let(:qiniu_image) { described_class.new(valid_data2) }

    it { expect(qiniu_image).to be_valid }
    it { expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><div class="editor_js--qiniu_image__picture editor_js--qiniu_image__picture--with-background editor_js--qiniu_image__picture--with-border"><img src="http://xxx/image2.png"></img></div><div class="editor_js--qiniu_image__caption">七牛2&lt;/div&gt;</div></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛2</div>') }
  end


  context 'with valid data; image style stretched' do
    let(:qiniu_image) { described_class.new(valid_data3) }

    it { expect(qiniu_image).to be_valid }
    it { expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><div class="editor_js--qiniu_image__picture editor_js--qiniu_image__picture--stretched"><img src="http://xxx/image3.png"></img></div><div class="editor_js--qiniu_image__caption">七牛2&lt;/div&gt;</div></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛2</div>') }
  end

  context 'with valid data; image style withBorder、withBackground、stretched and 驼峰类型命名' do
    let(:qiniu_image) { described_class.new(valid_data4) }

    it { expect(qiniu_image).to be_valid }
    it {
      expect(qiniu_image.render).to eq(%|<div class="editor_js--qiniu_image"><div class="editor_js--qiniu_image__picture editor_js--qiniu_image__picture--stretched editor_js--qiniu_image__picture--with-background editor_js--qiniu_image__picture--with-border"><img src="http://xxx/f.image4.png"></img></div><div class="editor_js--qiniu_image__caption">七牛4&lt;/div&gt;</div></div>|) }
    it { expect(qiniu_image.plain).to eq('七牛4</div>') }
  end

end
