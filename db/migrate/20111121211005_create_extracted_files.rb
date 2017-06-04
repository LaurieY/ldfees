class CreateExtractedFiles < ActiveRecord::Migration
  def self.up
    create_table :extracted_files do |t|
      t.string :name
      t.date :startdate
      t.date :enddate
      t.references :feefile

      t.timestamps
    end
  end

  def self.down
    drop_table :extracted_files
  end
end
