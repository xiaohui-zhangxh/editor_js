# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::HeaderBlock do
  let(:valid_data1) do
    {
      type: 'header',
      data: {
        text: 'this is a <b>header</b> <a>hacker</a> by &lt;b&gt;me&lt;/b&gt;',
        level: 2
      }
    }
  end

  let(:invalid_data1) do
    {
      type: 'header',
      data: {
        text: 'this is a <b>header</b> <a>hacker</a> by &lt;b&gt;me&lt;/b&gt;',
        level: 7
      }
    }
  end

  context 'with valid string' do
    let(:header) { described_class.new(valid_data1.to_json) }

    it { expect(header).to be_valid }
    it { expect(header.render).to eq(%|<h2 class="editor_js--header">this is a   by &lt;b&gt;me&lt;/b&gt;</h2>|) }
    it { expect(header.plain).to eq('this is a   by <b>me</b>') }
  end

  context 'with valid hash' do
    let(:header) { described_class.new(valid_data1) }

    it { expect(header).to be_valid }
  end

  it { expect(described_class.new(invalid_data1)).not_to be_valid }
end
