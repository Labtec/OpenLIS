# frozen_string_literal: true

module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title, page_title.to_s) if show_title
  end
end
