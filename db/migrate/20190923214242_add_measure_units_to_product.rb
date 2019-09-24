class AddMeasureUnitsToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :measure_unit, null: false, foreign_key: true
  end
end
