# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::QuoteBlock do
  let(:valid_data1) do
    {
      type: 'quote',
      data: {
        text: '这是第一段话&nbsp; abcdefg                    <div><br></div><div>这个是第二段话：999999</div><div><br></div><div>结尾语句</div>',
        caption: 'LiBai',
        alignment: 'left'
      }
    }
  end
  # alignment 暂不使用，不用测试

  context 'with valid data1' do
    let(:quote) { described_class.new(valid_data1) }

    it { expect(quote).to be_valid }

    it { expect(quote.render).to eq(%|<div class="editor_js--quote"><div class="editor_js--quote__text">这是第一段话&nbsp; abcdefg                     <br>  这个是第二段话：999999  <br>  结尾语句 </div><div class="editor_js--quote__caption">LiBai</div></div>|) }
    it { expect(quote.plain).to eq('这是第一段话  abcdefg                        这个是第二段话：999999     结尾语句, LiBai') }
  end

end
