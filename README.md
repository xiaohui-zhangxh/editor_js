# EditorJs

[![Gem Version](https://badge.fury.io/rb/editor_js.svg)](https://badge.fury.io/rb/editor_js) [![Build Status](https://travis-ci.org/xiaohui-zhangxh/editor_js.svg?branch=master)](https://travis-ci.org/xiaohui-zhangxh/editor_js) [![Maintainability](https://api.codeclimate.com/v1/badges/e26bf8e27fb3a33735fd/maintainability)](https://codeclimate.com/github/xiaohui-zhangxh/editor_js/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e26bf8e27fb3a33735fd/test_coverage)](https://codeclimate.com/github/xiaohui-zhangxh/editor_js/test_coverage) ![Downloads](https://ruby-gem-downloads-badge.herokuapp.com/editor_js?type=total)

A Ruby renderer for EditorJS https://editorjs.io/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'editor_js'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install editor_js

## Usage

**Parse document:**

```ruby
doc = EditorJs::Document.new(editor_js_output)
doc.render  # [String] render HTML for display
doc.plain   # [String] render text for full-text searching
doc.output  # [Hash] return sanitized data

```

**Capture invalid block:**

```ruby
class MyInvalidBlockRender do
  def initialize(raw)
    @raw = raw
    # can record/log invalid block from here:
    # Sentry.capture_message "invalid block: #{raw}"
  end

  def valid?
    false
  end

  def render
    '<div>invalid block</div>'
  end

  def plain; end
  def output; {} end
end

doc = EditorJs::Document.new(editor_js_output, invalid_block_renderer: MyInvalidBlockRender)
doc.render  # [String] render HTML for display
doc.plain   # [String] render text for full-text searching
doc.output  # [Hash] return sanitized data

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiaohui-zhangxh/editor_js.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
