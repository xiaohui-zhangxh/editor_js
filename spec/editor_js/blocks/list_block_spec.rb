# frozen_string_literal: true

RSpec.describe EditorJs::Blocks::ListBlock do
  let(:valid_data1) do
    {
      type: 'list',
      data: {
        style: 'ordered',
        items: [
          "item <b>hacker</b> &lt;1&gt;<strong>大字体</strong>《没》<i>斜体<i><a href='www.baidu.com' class='red' data-href='nodata'>go baidu<a>",
          'item &lt;2&gt;',
          'item 3'
        ]
      }
    }
  end

  let(:valid_data2) do
    {
      type: 'list',
      data: {
        style: 'unordered',
        items: [
          "列表2 <b>hacker</b> &lt;1&gt;<strong>大字体</strong>《没》<i>斜体<i><a href='www.baidu.com' class='red' data-href='nodata'>go baidu<a>",
          '列表2 &lt;2&gt;《<html>body<html>',
          '列表2 3'
        ]
      }
    }
  end

  let(:valid_data3) do
    {
      type: 'list',
      data: {
        style: 'ordered',
        items: [
          {
            content: "列表2 <b>hacker</b> &lt;1&gt;<strong>大字体</strong>《没》<i>斜体<i><a href='www.baidu.com' class='red' data-href='nodata'>go baidu<a>",
            items: [
              {
                content: '列表2 &lt;2&gt;《<html>body<html>',
                items: []
              }
            ]
          },
          {
            content: '列表2 3',
            items: []
          }
        ]
      }
    }
  end

  let(:valid_data4) do
    {
      type: 'list',
      data: {
        style: 'unordered',
        items: [
          {
            content: "列表2 <b>hacker</b> &lt;1&gt;<strong>大字体</strong>《没》<i>斜体<i><a href='www.baidu.com' class='red' data-href='nodata'>go baidu<a>",
            items: [
              {
                content: '列表2 &lt;2&gt;《<html>body<html>',
                items: []
              }
            ]
          },
          {
            content: '列表2 3',
            items: []
          }
        ]
      }
    }
  end

  context 'non-nested' do
    context 'ordered list' do
      let(:list) { described_class.new(valid_data1) }

      it { expect(list).to be_valid }
      it { expect(list.render).to eq(%|<ol class=\"editor_js--list\" type=\"1\"><li>item <b>hacker</b> &lt;1&gt;《没》<i>斜体<i><a href=\"www.baidu.com\">go baidu</a><a></a></i></i></li><li>item &lt;2&gt;</li><li>item 3</li></ol>|) }
      it { expect(list.plain).to eq('item hacker <1>《没》斜体go baidu, item <2>, item 3') }
    end

    context 'unordered list' do
      let(:list) { described_class.new(valid_data2) }

      it { expect(list).to be_valid }
      it { expect(list.render).to eq(%|<ul class=\"editor_js--list\" type=\"disc\"><li>列表2 <b>hacker</b> &lt;1&gt;《没》<i>斜体<i><a href=\"www.baidu.com\">go baidu</a><a></a></i></i></li><li>列表2 &lt;2&gt;《body</li><li>列表2 3</li></ul>|) }
      it { expect(list.plain).to eq('列表2 hacker <1>《没》斜体go baidu, 列表2 <2>《body, 列表2 3') }
    end
  end

  context 'nested' do
    context 'ordered list' do
      let(:list) { described_class.new(valid_data3) }

      it { expect(list).to be_valid }
      it do
        expect(list.render).to eq("<ol class=\"editor_js--list\" type=\"1\"><li>列表2 <b>hacker</b> &lt;1&gt;《没》<i>斜体<i><a href=\"www.baidu.com\">go baidu</a><a></a></i></i><ol class=\"editor_js--list\" type=\"a\"><li>列表2 &lt;2&gt;《body</li></ol></li><li>列表2 3</li></ol>")
      end
      it { expect(list.plain).to eq("列表2 hacker <1>《没》斜体go baidu, 列表2 <2>《body, 列表2 3") }
    end

    context 'unordered list' do
      let(:list) { described_class.new(valid_data3) }

      it { expect(list).to be_valid }
      it { expect(list.render).to eq("<ol class=\"editor_js--list\" type=\"1\"><li>列表2 <b>hacker</b> &lt;1&gt;《没》<i>斜体<i><a href=\"www.baidu.com\">go baidu</a><a></a></i></i><ol class=\"editor_js--list\" type=\"a\"><li>列表2 &lt;2&gt;《body</li></ol></li><li>列表2 3</li></ol>") }
      it { expect(list.plain).to eq("列表2 hacker <1>《没》斜体go baidu, 列表2 <2>《body, 列表2 3") }
    end
  end
end
