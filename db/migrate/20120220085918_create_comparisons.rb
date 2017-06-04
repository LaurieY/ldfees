class CreateComparisons < ActiveRecord::Migration
  def change
    create_table :comparisons do |t|
      t.integer :reference4
      t.integer :reference2
      t.string :owner
      t.string :property
      t.decimal :sbalance,:precision=> 8,:scale=>2 
      t.decimal :obalance,:precision=> 8,:scale=>2 ,:default=>0
      t.boolean :indicator
    end
  end
end
