# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::WarningBlock do
  let(:valid_data) do
    {
      type: 'warning',
      data: {
        title: 'Note:',
        message: '<b>Avoid using this method just for lulz</b>. It can be very dangerous opposite your daily fun stuff.'
      }
    }
  end

  context 'with valid data' do
    let(:quote) { described_class.new(valid_data) }

    it { expect(quote).to be_valid }

    it { expect(quote.render).to eq(%|<div class="editor_js--warning"><div class="editor_js--warning__title">Note:</div><div class="editor_js--warning__message"><b>Avoid using this method just for lulz</b>. It can be very dangerous opposite your daily fun stuff.</div></div>|) }
    it { expect(quote.plain).to eq('Note:, Avoid using this method just for lulz. It can be very dangerous opposite your daily fun stuff.') }
  end

end
