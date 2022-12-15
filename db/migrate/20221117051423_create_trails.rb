class CreateTrails < ActiveRecord::Migration[7.0]
  def change
    create_table :trails do |t|
      t.string :name
      t.integer :age_minimum
      t.integer :age_maximum
      t.integer :body_build
      t.float :weight_minimum
      t.float :weight_maximum

      t.timestamps
    end
  end
end
