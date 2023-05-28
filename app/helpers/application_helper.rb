# frozen_string_literal: true

module ApplicationHelper
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def render_error_messages(*objects)
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    render 'error_messages', object: messages unless messages.empty?
  end

  def render_markdown(text)
    return unless text

    sanitize(CommonMarker.render_html(text), tags: %w[strong em])
  end

  def navigation(*links)
    items = []
    links.each do |link|
      items << if controller.controller_name.to_sym == link[0] || "admin_#{controller.controller_name}".to_sym == link[0]
                 tag.li(link_to((link[1]).to_s, link[0]), class: 'active')
               else
                 tag.li(link_to((link[1]).to_s, link[0]))
               end
    end
    if controller.controller_name.to_s == 'claims'
      items.delete_at(2)
      items.insert(2, tag.li(link_to(t('.insurance_providers'), :admin_insurance_providers), class: 'active'))
    end
    tag.ul(safe_join(items))
  end
end
