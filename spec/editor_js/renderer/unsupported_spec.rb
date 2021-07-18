# frozen_string_literal: true

require 'action_controller'
require 'active_support/all'

RSpec.describe EditorJS::Renderer::Unsupported do
  let(:tag_helper) { ActionController::Base.helpers }

  it do
    renderer = described_class.new
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--unsupported">Unsupported block type!</div>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new class_name: 'block--my-unsupported'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--my-unsupported">Unsupported block type!</div>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new tag_name: 'span'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<span class="block--unsupported">Unsupported block type!</span>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new message: 'unsupported message'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--unsupported">unsupported message</div>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new message: ''
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq ''
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new message: nil
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq ''
    expect(renderer.render_text(nil)).to eq ''
  end
end
