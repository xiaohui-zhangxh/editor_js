# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::DelimiterBlock do
  let(:valid_data1) do
    {
      type: 'delimiter',
      data: {}
    }
  end

  context 'with valid data' do
    let(:delimiter) { described_class.new(valid_data1) }

    it { expect(delimiter).to be_valid }
    it { expect(delimiter.render).to eq(%|<hr class="editor_js--delimiter"></hr>|) }
    it { expect(delimiter.plain).to eq('') }
  end
end
