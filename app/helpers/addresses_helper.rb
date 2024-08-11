# frozen_string_literal: true

module AddressesHelper
  def map_link(province, district, corregimiento)
    link_to t(".map"), "https://www.google.com/maps/place/+#{corregimiento},+#{district},+#{province},+Panamá", target: :_blank, rel: :noopener, id: :patient_address_map, data: { address_target: :map }
  end

  def options_for_province
    provinces = []

    (Address::PROVINCES + Address::COMARCAS).each do |id|
      provinces << Address::SUBDIVISIONS["provinces"]["pa_#{id}"]["name"]
    end

    provinces
  end

  def options_for_district
    provinces = []

    (Address::PROVINCES + Address::COMARCAS).each do |id|
      districts = []
      Address::SUBDIVISIONS["provinces"]["pa_#{id}"]["districts"].each do |d|
        districts << d["name"] unless d["name"].nil?
      end
      provinces << [ Address::SUBDIVISIONS["provinces"]["pa_#{id}"]["name"], districts ]
    end

    provinces
  end

  def options_for_corregimiento
    districts = []

    (Address::PROVINCES + Address::COMARCAS).each do |id|
      Address::SUBDIVISIONS["provinces"]["pa_#{id}"]["districts"].each do |d|
        # Handle Guna Yala's special case, where there are no
        # districts, only corregimientos
        districts << if d["name"]
                       [ d["name"], d["corregimientos"] ]
        else
                       [ Address::SUBDIVISIONS["provinces"]["pa_#{id}"]["name"],
                        d["corregimientos"] ]
        end
      end
    end

    districts
  end
end
