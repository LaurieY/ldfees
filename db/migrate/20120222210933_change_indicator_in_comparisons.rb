class ChangeIndicatorInComparisons < ActiveRecord::Migration
  def up
    change_column :comparisons,:indicator, :string
  end

  def down
    change_column :comparisons, :indicator, :boolean
  end
end
