class EnableUnaccentExtension < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'unaccent'
  end
end
