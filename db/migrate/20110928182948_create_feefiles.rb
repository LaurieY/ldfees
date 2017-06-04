class CreateFeefiles < ActiveRecord::Migration
  def self.up
    create_table :feefiles do |t|
      t.string :feefilename
      t.string :feefiletitle
      t.string :feefiletype

      t.timestamps
    end
  end

  def self.down
    drop_table :feefiles
  end
end
