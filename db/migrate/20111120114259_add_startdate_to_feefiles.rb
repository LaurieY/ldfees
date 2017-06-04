class AddStartdateToFeefiles < ActiveRecord::Migration
  def self.up
        add_column :feefiles, :startdate, :date
  end

  def self.down
        remove_column :feefiles, :startdate
  end
end
