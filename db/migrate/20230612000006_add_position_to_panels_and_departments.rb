class AddPositionToPanelsAndDepartments < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :position, :integer, index: true, unique: true
    add_column :panels, :position, :integer, index: true, unique: true

    Department.all.each.with_index(1) do |department, index|
      department.update_column :position, index
    end

    Panel.order(name: :asc).each.with_index(1) do |panel, index|
      panel.update_column :position, index
    end
  end
end
