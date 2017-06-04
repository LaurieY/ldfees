class AddDebtorToFeefile < ActiveRecord::Migration
  def self.up
    add_column :feefiles, :debtorfilename, :string
    add_column :feefiles, :debtorstartdate, :date
  end

  def self.down
    remove_column :feefiles, :debtorfilename
    remove_column :feefiles, :debtorstartdate
  end
end
