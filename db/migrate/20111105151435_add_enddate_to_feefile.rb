class AddEnddateToFeefile < ActiveRecord::Migration
  def self.up
    add_column :feefiles, :enddate, :date
  end

  def self.down
    remove_column :feefiles, :enddate
  end
end
