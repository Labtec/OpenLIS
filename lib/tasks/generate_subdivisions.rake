# frozen_string_literal: true

require "csv"
require "yaml"

namespace :subdivisions do
  desc "Generate subdivisions.yml from subdivisions.csv"

  task generate: :environment do
    puts "Generating YAML file"

    # Read and parse the CSV file
    subdivisions = []
    CSV.foreach("app/models/subdivisions.csv", headers: true) do |subdivision|
      subdivisions << subdivision.to_h
    end

    # Organize by province, district, and corregimiento
    provinces = {}

    subdivisions.each do |subdivision|
      province_id = subdivision["province_id"]
      province_name = subdivision["province"]
      district_id = subdivision["district_id"]
      district_name = subdivision["district"]
      corregimiento_id = subdivision["corregimiento_id"]
      corregimiento_name = subdivision["corregimiento"]
      cabecera = subdivision["cabecera"] == "1" ? corregimiento_name : nil
      inactive = subdivision["inactive"] == "1" ? true : false

      # Create provinces
      unless provinces.key?(province_id)
        provinces[province_id] = {
          id: province_id,
          name: province_name,
          districts: {}
        }
      end

      # Create districts
      unless provinces[province_id][:districts].key?(district_id)
        provinces[province_id][:districts][district_id] = {
          id: "#{province_id}-#{district_id}",
          name: district_name,
          corregimientos: []
        }
      end

      # Create corregimientos
      corregimiento_data = {
        id: subdivision["id"],
        name: corregimiento_name
      }

      # Add cabecera to district
      provinces[province_id][:districts][district_id][:cabecera] = cabecera if cabecera

      unless inactive
        provinces[province_id][:districts][district_id][:corregimientos] << corregimiento_data
      end
    end

    # YAML structure
    yaml_data = {
      "provinces" => {}
    }

    provinces.each do |province_id, province_data|
      # https://www.iso.org/obp/ui/#iso:code:3166:PA
      case province_id
      when "10"
        province_id = "ky"
      when "11"
        province_id = "em"
      when "12"
        province_id = "nb"
      when "13"
        province_id = "10"
      end
      province_key = "pa_#{province_id}"

      yaml_data["provinces"][province_key] = {
        id: province_data[:id],
        name: province_data[:name],
        districts: []
      }.compact

      province_data[:districts].each_value do |district_data|
        district = {
          id: district_data[:id],
          name: district_data[:name],
          cabecera: district_data[:cabecera],
          corregimientos: district_data[:corregimientos]
        }.compact
        yaml_data["provinces"][province_key][:districts] << district
      end
    end

    # Sort
    sort_order = Address::PROVINCES.map { |p| "pa_#{p}" } + Address::COMARCAS.map { |c| "pa_#{c}" }
    sort_positions = sort_order.each_with_index.to_h
    yaml_data["provinces"] = yaml_data["provinces"].sort_by { |key, _| sort_positions[key] }.to_h

    # Write to YAML file
    File.open("app/models/subdivisions.yml", "w") do |file|
      file.write("---\n")
      file.write("# DO NOT EDIT - This file is generated from subdivisions.csv\n")
      file.write("# https://www.iso.org/obp/ui/#iso:code:3166:PA\n")

      # Manually format the YAML to be yamllint compatible
      file.write("provinces:\n")

      yaml_data["provinces"].each do |key, province|
        file.write("  #{key}:\n")
        # file.write("    id: \"#{province[:id]}\"\n")
        file.write("    name: #{province[:name].gsub(/^Comarca /, "")}\n")
        file.write("    indigenous_region: true\n") if province[:name].match(/^Comarca /)
        file.write("    districts:\n")

        province[:districts].each do |district|
          file.write("      -\n")
          # file.write("        id: \"#{district[:id]}\"\n")
          file.write("        name: #{district[:name].gsub(/^Comarca /, "")}\n")
          file.write("        cabecera: #{district[:cabecera].gsub(/^Comarca /, "")}\n") if district[:cabecera]
          file.write("        corregimientos:\n")

          district[:corregimientos].each do |corregimiento|
            # file.write("          -\n")
            # file.write("            id: \"#{corregimiento[:id]}\"\n")
            # file.write("            name: #{corregimiento[:name]}\n")
            file.write("          - #{corregimiento[:name]}\n")
          end
        end
      end
    end

    puts "Done!"
  end
end
