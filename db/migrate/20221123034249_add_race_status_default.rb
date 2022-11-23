class AddRaceStatusDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :races, :status, 0
  end
end
