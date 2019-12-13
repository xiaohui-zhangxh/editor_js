# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::HeaderBlock do
  let(:valid_data1) do
    {
      type: 'header',
      data: {
        text: '圆括号的特殊语法《不知道》+ 1 ^zou 明天',
        level: 5,
      }
    }
  end

  context 'with valid string' do
    let(:header) { described_class.new(valid_data1.to_json) }

    it { expect(header).to be_valid }
    it { expect(header.render).to eq(%|<h5 class="editor_js--header">圆括号的特殊语法《不知道》+ 1 ^zou 明天</h5>|) }
    it {expect(header.plain).to eq('圆括号的特殊语法《不知道》+ 1 ^zou 明天') }
  end

  context 'with valid hash' do
    let(:header) { described_class.new(valid_data1) }

    it { expect(header).to be_valid }
  end
end
