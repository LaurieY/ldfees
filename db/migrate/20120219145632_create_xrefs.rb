class CreateXrefs < ActiveRecord::Migration
  def change
    create_table :xrefs do |t|
      t.string :santiagoref
      t.string :property
      t.integer :ocm4digitcode
      t.integer :ocmref

      t.timestamps
    end
  end
end
