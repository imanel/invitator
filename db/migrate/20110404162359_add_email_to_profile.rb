class AddEmailToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :email, :string
  end

  def self.down
    remove_column :profiles, :email
  end
end
