class CreateCountdownUsers < ActiveRecord::Migration
  def change
    create_table :countdown_users do |t|
      t.string   :email
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.integer  :school_id

      t.timestamps
    end

    add_index :countdown_users, :email,                :unique => true
    add_index :countdown_users, :confirmation_token,   :unique => true
  end
end
