# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      ## Authenticatable
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
