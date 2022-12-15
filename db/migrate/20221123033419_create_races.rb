class CreateRaces < ActiveRecord::Migration[7.0]
  def change
    create_table :races do |t|
      t.string :name
      t.integer :status
      t.datetime :start
      t.datetime :end
      t.float :duration
      t.integer :winner
      t.references :trail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
