# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::MarkdownBlock do
  let(:valid_data1) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        - nihao
        - zaijian

        #### 来投票
        * [ ] 投票
        * [x] 不投票

        ```javascript
        function hello() {
          console.log('hello')
        }
        ```
        ```html
        <h1>This is header</h1>
        ```

        plain text

        |   字段 |   类型 |   描述 | |
        | ------ | ------ | ------ | --- |
        | identifier |

        ++新消息++

        **撒地方**

        *斜体*

        ~~这是啥~~

        $1+1=2$

        ```math
        c = \pm \sqrt{a^2 + b^2}
        ```

        $$c = \pm \sqrt{a^3 + b^5}$$
        MARKDOWN
      }
    }
  end

  context 'with valid data' do
    let(:markdown) { described_class.new(valid_data1) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><ul>
      <li>nihao
      </li><li>zaijian
      </li></ul>
      <h4>来投票</h4>
      <ul>
      <li><input type='checkbox' disabled> 投票
      </li><li><input type='checkbox' checked='checked' disabled> 不投票
      </li></ul>
      <div class="CodeRay">
        <div class="code"><pre><span class="keyword">function</span> <span class="function">hello</span>() {
        console.log(<span class="string"><span class="delimiter">'</span><span class="content">hello</span><span class="delimiter">'</span></span>)
      }
      </pre></div>
      </div>
      <div class="CodeRay">
        <div class="code"><pre><span class="tag">&lt;h1&gt;</span>This is header<span class="tag">&lt;/h1&gt;</span>
      </pre></div>
      </div>
      <p>plain text</p>
      <table><thead>
      <tr>
      <th>字段</th>
      <th>类型</th>
      <th>描述</th>
      <th></th>
      </tr>
      </thead><tbody>
      <tr>
      <td>identifier</td>
      <td></td>
      <td></td>
      <td></td>
      </tr>
      </tbody></table>
      <p>++新消息++</p><p><strong>撒地方</strong></p><p><em>斜体</em></p><p><del>这是啥</del></p><p><span class="markdown_math-inline_block">1%2B1%3D2</span></p><div class="markdown_math-block">c%20%3D%20pm%20%20qrt%7Ba%5E2%20%2B%20b%5E2%7D%0A</div><p><div class="markdown_math-block">c%20%3D%20pm%20%20qrt%7Ba%5E3%20%2B%20b%5E5%7D</div></p></div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data1[:data][:text].strip) }
  end

end
