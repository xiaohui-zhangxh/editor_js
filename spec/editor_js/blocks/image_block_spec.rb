# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ImageBlock do
  let(:valid_data1) do
    {
      type: 'image',
      data: {
        url: 'http://assets.wedxt.com/1576156689709-%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-10-15%2021.34.57.png',
        caption: 'asdasdf sadfsadf &lt;asdf &gt;&lt;fff&gt;&gt;&gt; &lt;div&gt;asdf . fasf &lt;/div&gt;',
        withBorder: false,
        withBackground: false,
        stretched: false
      }
    }
  end
  # encryped_id: ''

  context 'with valid string' do
    let(:embed) { described_class.new(valid_data1.to_json) }

    it { expect(embed).to be_valid }

    it { expect(embed.render).to eq(%|<div class="editor_js--image"><div class="simple-image__picture"><img src="http://assets.wedxt.com/1576156689709-%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-10-15%2021.34.57.png"></img></div><div class="simple-image__caption">asdasdf sadfsadf &lt;asdf &gt;&lt;fff&gt;&gt;&gt; &lt;div&gt;asdf . fasf &lt;/div&gt;</div></div>|) }
    it { expect(embed.plain).to eq('asdasdf sadfsadf <asdf ><fff>>> <div>asdf . fasf </div>') }
  end

  context 'with valid hash' do
    let(:embed) { described_class.new(valid_data1) }

    it { expect(embed).to be_valid }
  end
end
