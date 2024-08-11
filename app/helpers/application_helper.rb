# frozen_string_literal: true

module ApplicationHelper
  def shallow_args(parent, child)
    child.try(:new_record?) ? [ parent, child ] : child
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def render_error_messages(*objects)
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    render "error_messages", object: messages unless messages.empty?
  end

  def render_markdown(text)
    return unless text

    sanitize(Commonmarker.to_html(text, options: { parse: { smart: true } }), tags: %w[em p strong])
  end

  def render_markdown_pdf(text)
    return unless text

    sanitize(Commonmarker.to_html(text, options: { parse: { smart: true } }), tags: %w[em strong]).chomp
  end

  def navigation(*links)
    items = []
    links.each do |link|
      items << if controller.controller_name.to_sym == link[0] || "admin_#{controller.controller_name}".to_sym == link[0]
                 tag.li(link_to((link[1]).to_s, link[0]), class: "active")
      else
                 tag.li(link_to((link[1]).to_s, link[0]))
      end
    end
    if controller.controller_name.to_s == "claims"
      items.delete_at(2)
      items.insert(2, tag.li(link_to(t(".insurance_providers"), :admin_insurance_providers), class: "active"))
    end
    tag.ul(safe_join(items))
  end
end
