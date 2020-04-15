# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::AttachesBlock do
  let(:valid_data1) do
    {
      type: 'attaches',
      data: {
        file: {
          url: 'http://assets.wedxt.com/a30c503e-1c51-4d10-98d0-4890a35b54f1/20190318-090749-a875f093-4f90-403a-87fc-a4708dff473a1586933733151.doc',
          name: "20190318-090749-a875f093-4f90-403a-87fc-a4708dff473a.doc",
          type: "application/msword",
          size: 36352
        },
        title: "20190318-090749-a875f093-4f90-403a-87fc-a4708dff473a.doc"
      }
    }
  end

  context 'with valid data' do
    let(:attaches) { described_class.new(valid_data1) }

    it { expect(attaches).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--attaches"><div class="editor_js--attaches__file-icon" data-extension="doc" style="color: #3e74da;"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="40"><path d="M17 0l15 14V3v34a3 3 0 0 1-3 3H3a3 3 0 0 1-3-3V3a3 3 0 0 1 3-3h20-6zm0 2H3a1 1 0 0 0-1 1v34a1 1 0 0 0 1 1h26a1 1 0 0 0 1-1V14H17V2zm2 10h7.926L19 4.602V12z"></path></svg></div><div class="editor_js--attaches__file-info"><div class="editor_js--attaches__title">20190318-090749-a875f093-4f90-403a-87fc-a4708dff473a.doc</div><div class="editor_js--attaches__size">35.5 KB</div></div><a class="editor_js--attaches__download-button" href="http://assets.wedxt.com/a30c503e-1c51-4d10-98d0-4890a35b54f1/20190318-090749-a875f093-4f90-403a-87fc-a4708dff473a1586933733151.doc" target="_blank" rel="nofollow noindex noreferrer"><svg xmlns="http://www.w3.org/2000/svg" width="17pt" height="17pt" viewBox="0 0 17 17"><path d="M9.457 8.945V2.848A.959.959 0 0 0 8.5 1.89a.959.959 0 0 0-.957.957v6.097L4.488 5.891a.952.952 0 0 0-1.351 0 .952.952 0 0 0 0 1.351l4.687 4.688a.955.955 0 0 0 1.352 0l4.687-4.688a.952.952 0 0 0 0-1.351.952.952 0 0 0-1.351 0zM3.59 14.937h9.82a.953.953 0 0 0 .953-.957.952.952 0 0 0-.953-.953H3.59a.952.952 0 0 0-.953.953c0 .532.425.957.953.957zm0 0" fill-rule="evenodd"></path></svg></a></div>
      HTML
      expect(attaches.render).to eq(html)
    end
    it { expect(attaches.plain).to eq(valid_data1[:data][:title].strip) }
  end
end
