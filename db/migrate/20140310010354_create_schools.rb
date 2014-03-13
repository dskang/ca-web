class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :signups, default: 0
      t.timestamps
    end

    add_index :schools, :name, :unique => true
  end
end
