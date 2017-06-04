class CreateDebtorFiles < ActiveRecord::Migration
  def self.up
    create_table :debtor_files do |t|
      t.string :name
      t.date :startdate
      t.date :enddate
      t.references :feefile
      t.timestamps
    end
  end
   def self.down
    drop_table :debtors_files
  end
end
