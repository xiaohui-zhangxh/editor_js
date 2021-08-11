# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::MarkdownBlock do
  let(:valid_data_base) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        - 无序列表1
        - 无序列表2, <script>非法标签</script>

        #### 来投票
        * [ ] 投票 <b>行内b标签</b><h1>h标签不应该存在</h1>
        * [x] 不投票<b>行内b标签，无结束标签

        ```javascript
        function hello() {
          console.log('hello')
        }

        <script>alert('js code')</script>
        ```
        ```html
        <h1>This is header</h1>
        ```

        <script>alert('js code error')</script>
        plain text

        |   字段 |   类型 |   描述 | |
        | ------ | ------ | ------ | --- |
        | identifier |

        ++新消息++

        **撒地方**

        *斜体*

        ~~这是啥~~
        MARKDOWN
      }
    }
  end

  context 'with valid data:base' do
    let(:markdown) { described_class.new(valid_data_base) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><ul>
      <li>无序列表1</li>
      <li>无序列表2,</li>
      </ul>
      <h4>来投票</h4>
      <ul>
      <li class="task-list-item"><input type="checkbox" disabled="" /> 投票 <b>行内b标签</b></li>
      <li class="task-list-item"><input type="checkbox" checked="" disabled="" /> 不投票<b>行内b标签，无结束标签</li>
      </ul>
      <div class="highlighter-rouge language-javascript"><div class="highlight"><pre class="codehilite"><code><span style="color: #000000;font-weight: bold">function</span> <span style="background-color: #f8f8f8">hello</span><span style="background-color: #f8f8f8">()</span> <span style="background-color: #f8f8f8">{</span>
        <span style="background-color: #f8f8f8">console</span><span style="background-color: #f8f8f8">.</span><span style="background-color: #f8f8f8">log</span><span style="background-color: #f8f8f8">(</span><span style="color: #d14">'</span><span style="color: #d14">hello</span><span style="color: #d14">'</span><span style="background-color: #f8f8f8">)</span>
      <span style="background-color: #f8f8f8">}</span>

      <span style="color: #000000;font-weight: bold">&lt;</span><span style="background-color: #f8f8f8">script</span><span style="color: #000000;font-weight: bold">&gt;</span><span style="background-color: #f8f8f8">alert</span><span style="background-color: #f8f8f8">(</span><span style="color: #d14">'</span><span style="color: #d14">js code</span><span style="color: #d14">'</span><span style="background-color: #f8f8f8">)</span><span style="color: #000000;font-weight: bold">&lt;</span><span style="color: #009926">/script</span><span style="color: #a61717;background-color: #e3d2d2">&gt;
      </span></code></pre></div></div>
      <div class="highlighter-rouge language-html"><div class="highlight"><pre class="codehilite"><code><span style="color: #000080">&lt;h1&gt;</span>This is header<span style="color: #000080">&lt;/h1&gt;</span>
      </code></pre></div></div>
      <p>plain text</p>
      <table>
      <thead>
      <tr>
      <th>字段</th>
      <th>类型</th>
      <th>描述</th>
      <th></th>
      </tr>
      </thead>
      <tbody>
      <tr>
      <td>identifier</td>
      <td></td>
      <td></td>
      <td></td>
      </tr>
      </tbody>
      </table>
      <p>++新消息++</p>
      <p><strong>撒地方</strong></p>
      <p><em>斜体</em></p>
      <p><del>这是啥</del><br />
      </b></p>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_base[:data][:text].strip) }
  end

  let(:valid_data_footnotes) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        Hello[^hi].
        [^hi]: Hey!

        MARKDOWN
      }
    }
  end
  context 'with valid data: footnotes' do
    let(:markdown) { described_class.new(valid_data_footnotes) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><p>Hello<sup class="footnote-ref"><a href="#fn1" id="fnref1">1</a></sup>.</p>
      <section class="footnotes">
      <ol>
      <li id="fn1">
      <p>Hey! <a href="#fnref1" class="footnote-backref">↩</a></p>
      </li>
      </ol>
      </section>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_footnotes[:data][:text].strip) }
  end

  let(:valid_data_html) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        <img src="//www.p.jpg" alt="img 1">
        <img src="https://www.p2.jpg" alt="img 2">
        <b>b tag</b>
        <em>em tag</em>
        <i>i tag</i>
        <strong>strong tag</strong>
        <u>u tag</u>
        <a>a tag</a>
        <abbr>abbr tag</abbr>
        <blockquote>blockquote tag</blockquote>
        <br/>
        <cite>cite tag</cite>
        <code>code tag</code>
        <dd>dd tag</dd>
        <dfn>dfn tag</dfn>
        <dl>dl tag</dl>
        <dt>dt tag</dt>
        <kbd>kbd tag</kbd>
        <li>li tag</li>
        <mark>mark tag</mark>
        <ol>ol tag</ol>
        <p>p tag</p>
        <pre>pre tag</pre>
        <q>q tag</q>
        <s>s tag</s>
        <samp>samp tag</samp>
        <small>small tag</small>
        <strike>strike tag html5 不再支持</strike>
        文本<sub>sub tag</sub>
        text<sup>sup tag</sup>
        <time>2021/07/09</time>
        <ul>
          <li>list 2</li>
          <li>list 1</li>
        </ul>
        <ul type='square'>
          <li style='color: red'>list 2</li>
          <li>list 1</li>
        </ul>
        <var>var tag</var>

        MARKDOWN
      }
    }
  end
  context 'with valid data: html' do
    let(:markdown) { described_class.new(valid_data_html) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><p><b>b tag</b><br />
      <em>em tag</em><br />
      <i>i tag</i><br />
      <strong>strong tag</strong><br />
      <u>u tag</u><br />
      <a rel="nofollow">a tag</a><br />
      <abbr>abbr tag</abbr></p>
      <blockquote>blockquote tag</blockquote>
      <br>
      <cite>cite tag</cite>
      <code>code tag</code>
      <dd>dd tag</dd>
      <dfn>dfn tag</dfn>
      <dl>dl tag</dl>
      <dt>dt tag</dt>
      <kbd>kbd tag</kbd>
      <li>li tag</li>
      <mark>mark tag</mark>
      <ol>ol tag</ol>
      <p>p tag</p>
      <pre>pre tag</pre>
      <q>q tag</q>
      <s>s tag</s>
      <samp>samp tag</samp>
      <small>small tag</small>
      <strike>strike tag html5 不再支持</strike>
      文本<sub>sub tag</sub>
      text<sup>sup tag</sup>
      <time>2021/07/09</time>
      <ul>
        <li>list 2</li>
        <li>list 1</li>
      </ul>
      <ul type="square">
        <li>list 2</li>
        <li>list 1</li>
      </ul>
      <var>var tag</var>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_html[:data][:text].strip) }
  end

  let(:valid_data_list) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        - foo
        - bar
         - baz
          - boo

        1. a
        90. b

        ---
        4. start 4
        7. item 5

        MARKDOWN
      }
    }
  end
  context 'with valid data: list' do
    let(:markdown) { described_class.new(valid_data_list) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><ul>
      <li>foo</li>
      <li>bar</li>
      <li>baz</li>
      <li>boo</li>
      </ul>
      <ol>
      <li>a</li>
      <li>b</li>
      </ol>
      <hr />
      <ol start="4">
      <li>start 4</li>
      <li>item 5</li>
      </ol>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_list[:data][:text].strip) }
  end

  let(:valid_data_table) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        One extension:
        | a   | b   |
        | --- | --- |
        | c   | <i>d</i>   |
        | **x** | |

        Another extension:

        ~~hi~~

        MARKDOWN
      }
    }
  end
  context 'with valid data:table' do
    let(:markdown) { described_class.new(valid_data_table) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><p>One extension:</p>
      <table>
      <thead>
      <tr>
      <th>a</th>
      <th>b</th>
      </tr>
      </thead>
      <tbody>
      <tr>
      <td>c</td>
      <td><i>d</i></td>
      </tr>
      <tr>
      <td><strong>x</strong></td>
      <td></td>
      </tr>
      </tbody>
      </table>
      <p>Another extension:</p>
      <p><del>hi</del></p>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_table[:data][:text].strip) }
  end

  let(:valid_data_task_list) do
    {
      type: 'markdown',
      data: {
        text: <<~MARKDOWN
        - [x] foo <h1>no<h1>
          - [ ] bar
          - [x] baz <small>strong text</small>
        - [ ] bim <b>strong text</b>
        MARKDOWN
      }
    }
  end
  context 'with valid data: task_list' do
    let(:markdown) { described_class.new(valid_data_task_list) }

    it { expect(markdown).to be_valid }
    it do
      html = <<~HTML.strip
      <div class="editor_js--markdown"><ul>
      <li class="task-list-item"><input type="checkbox" checked="" disabled="" /> foo</li>
      </ul>
      </div>
      HTML
      expect(markdown.render).to eq(html)
    end
    it { expect(markdown.plain).to eq(valid_data_task_list[:data][:text].strip) }
  end
end
