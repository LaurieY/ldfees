class AddOcmRefToDebtors < ActiveRecord::Migration
  def change
    add_column :debtors, :ocmref, :int
  end
end
