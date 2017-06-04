class AddExtractToFeefile < ActiveRecord::Migration
  def self.up
    add_column :feefiles, :extractfilename, :string
    add_column :feefiles, :extractstartdate, :date
  end

  def self.down
    remove_column :feefiles, :extractstartdate
    remove_column :feefiles, :extractfilename
  end
end
