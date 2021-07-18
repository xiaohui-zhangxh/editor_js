# frozen_string_literal: true

require 'action_controller'
require 'active_support/all'

RSpec.describe EditorJS::Renderer::Invalid do
  let(:tag_helper) { ActionController::Base.helpers }

  it do
    renderer = described_class.new
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--invalid">Invalid block!</div>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new class_name: 'block--my-invalid'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--my-invalid">Invalid block!</div>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new tag_name: 'span'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<span class="block--invalid">Invalid block!</span>'
    expect(renderer.render_text(nil)).to eq ''
  end

  it do
    renderer = described_class.new message: 'invalid'
    expect(renderer.render_html(nil, tag_helper: tag_helper)).to eq '<div class="block--invalid">invalid</div>'
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
