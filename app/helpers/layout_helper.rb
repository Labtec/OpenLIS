# frozen_string_literal: true

module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title, page_title.to_s) if show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
end
