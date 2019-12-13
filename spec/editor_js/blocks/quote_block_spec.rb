# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QuoteBlock do
  let(:valid_data1) do
    {
      type: 'quote',
      data: {
        text: 'This is a quote with <b>HTML</b> as &lt;b&gt;HTML&lt;/b&gt;<small>notext</small>',
        caption: 'LiBai',
        alignment: 'left'
      }
    }
  end
  # alignment 暂不使用，不用测试

  context 'with valid string1' do
    let(:quote) { described_class.new(valid_data1.to_json) }

    it { expect(quote).to be_valid }
    it { expect(quote.render).to eq(%|<div class="editor_js--quote"><div class="editor_js--quote__text">This is a quote with <b>HTML</b> as &lt;b&gt;HTML&lt;/b&gt;</div><div class="editor_js--quote__caption">LiBai</div></div>|) }
    it { expect(quote.plain).to eq('This is a quote with HTML as <b>HTML</b>, LiBai') }
  end

  context 'with valid hash' do
    let(:quote) { described_class.new(valid_data1) }

    it { expect(quote).to be_valid }
  end

end
