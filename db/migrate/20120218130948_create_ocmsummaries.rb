class CreateOcmsummaries < ActiveRecord::Migration
  def change
    create_table :ocmsummaries do |t|
      t.integer :ref
      t.string :property
      t.string :owner
      t.decimal :balance, :precision=> 8,:scale=>2

      t.timestamps
    end
  end
end
