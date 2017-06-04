class CreateExtracteds < ActiveRecord::Migration
  def self.up
    create_table :extracteds do |t|
      t.string :owner
      t.integer :reference
      t.string :property
      t.decimal :coefficient, :precision=> 8,:scale=>5
      t.date :adate
      t.string :subject
      t.decimal :fees, :precision=> 8,:scale=>2
      t.decimal :payments,:precision=> 8, :scale=>2
      t.references :feefile

      t.timestamps
    end
  end

  def self.down
    drop_table :extracteds
  end
end
