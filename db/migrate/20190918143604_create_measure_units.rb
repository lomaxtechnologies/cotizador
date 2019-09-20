class CreateMeasureUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :measure_units do |t|
      t.string :name
      t.string :unit_type

      t.timestamps
    end
  end
end
