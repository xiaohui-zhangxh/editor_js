# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::CodeBlock do
  let(:valid_data1) do
    {
      type: 'code',
      data: {
        code: <<~CODE
          <script language="javascript">
            function helloWorld(name){
              console.log(`hello ${name}, welcome to world!`)
            }
          </script>
        CODE
      }
    }
  end

  context 'with valid string' do
    let(:code) { described_class.new(valid_data1.to_json) }

    it { expect(code).to be_valid }
    it { expect(code.render).to eq(%|<code class="editor_js--code">&lt;script language=&quot;javascript&quot;&gt;\n  function helloWorld(name){\n    console.log(`hello ${name}, welcome to world!`)\n  }\n&lt;/script&gt;\n</code>|) }
    it { expect(code.plain).to eq(valid_data1[:data][:code].strip) }
  end

  context 'with valid hash' do
    let(:code) { described_class.new(valid_data1) }

    it { expect(code).to be_valid }
  end
end
