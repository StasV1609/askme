class AddIndexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, [:email, :username], unique: true
  end
end
