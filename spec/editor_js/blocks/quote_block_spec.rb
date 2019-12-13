# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QuoteBlock do
  let(:valid_data1) do
    {
      type: 'quote',
      data: {
        text: 'This is a quote with <b>HTML</b> as &lt;b&gt;HTML&lt;/b&gt;',
        caption: 'LiBai',
        alignment: 'left'
      }
    }
  end

  let(:valid_data2) do
    {
      type: 'quote',
      data: {
        text: 'This is a quote align to right',
        caption: 'LiBai',
        alignment: 'right'
      }
    }
  end

  context 'with valid string1' do
    let(:quote) { described_class.new(valid_data1.to_json) }

    it { expect(quote).to be_valid }
    it { expect(quote.render).to eq(%|<div class="editor_js--quote"><span class="editor_js--quote__text">This is a quote with HTML as &lt;b&gt;HTML&lt;/b&gt;</span><span class="editor_js--quote__caption">LiBai</span></div>|) }
    it { expect(quote.plain).to eq('This is a quote with HTML as <b>HTML</b>, LiBai') }
  end

  context 'with valid hash' do
    let(:quote) { described_class.new(valid_data1) }

    it { expect(quote).to be_valid }
  end

  context 'align to right' do
    let(:quote) { described_class.new(valid_data2.to_json) }

    it { expect(quote).to be_valid }
    it { expect(quote.render).to eq(%|<div class="editor_js--quote editor_js--quote--right"><span class="editor_js--quote__text">This is a quote align to right</span><span class="editor_js--quote__caption">LiBai</span></div>|) }
    it { expect(quote.plain).to eq('This is a quote align to right, LiBai') }
  end
end
