class CreatePractices < ActiveRecord::Migration[7.0]
  def change
    create_table :practices do |t|
      t.integer :status, default: 0
      t.references :person, null: false, foreign_key: true
      t.references :trail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
