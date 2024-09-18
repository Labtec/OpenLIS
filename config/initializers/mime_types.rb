# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Mime::Type.register_alias "application/smart-health-card", :smart_health_card, [ "smart-health-card" ]

Mime::Type.register "application/json", :json, %w[
  text/x-json
  application/jsonrequest
  application/problem+json
  application/smart-health-card
]
