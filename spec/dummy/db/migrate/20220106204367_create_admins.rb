# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      ## Authenticatable
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.timestamps null: false
    end
    add_index :admins, :email, unique: true
  end
end
