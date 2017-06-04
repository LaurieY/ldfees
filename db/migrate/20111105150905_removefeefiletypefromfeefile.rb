class Removefeefiletypefromfeefile < ActiveRecord::Migration
  def self.up
    remove_column :feefiles, :feefiletype
  end

  def self.down
    add_column :feefiles, :feefiletype, :string
  end
end
