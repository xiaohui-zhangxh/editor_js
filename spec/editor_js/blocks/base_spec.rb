RSpec.describe EditorJs::Blocks::Base do
  subject(:base) { described_class.new(type: 'base') }

  it { expect(base.decode_html('&nbsp;').ord).to eq 32 }
  it "HTMLEntities::MAPPINGS['expanded'] should not be changed" do
    base.decode_html('&nbsp;')
    expect(HTMLEntities::Decoder.new('expanded').decode('&nbsp;').ord).to eq 160
  end
  it { expect(base.css_name).to eq 'editor_js--base' }
  it { expect(base.css_name('__image')).to eq 'editor_js--base__image' }

  context "with customized css_prefix 'mycss'" do
    before { EditorJs.css_name_prefix = 'mycss--' }
    after { EditorJs.css_name_prefix = 'editor_js--' }

    it { expect(base.css_name).to eq 'mycss--base' }
    it { expect(base.css_name('__image')).to eq 'mycss--base__image' }
  end

end
