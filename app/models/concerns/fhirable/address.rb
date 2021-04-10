# frozen_string_literal: true

module FHIRable
  module Address
    extend ActiveSupport::Concern

    def fhirable_address
      return unless address_line

      [
        {
          use: 'home',
          type: 'physical',
          text: address_text,
          line: [
            address_line
          ],
          city: address_corregimiento,
          district: address_district,
          state: address_province,
          country: 'PAN'
        }
      ]
    end

    private

    def address_text
      [address_line, address_corregimiento, address_district, address_province, 'Panamá'].join(', ')
    end
  end
end
