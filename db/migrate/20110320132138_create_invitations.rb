class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :creator_id
      t.string :target_email
      t.string :subject
      t.text :content
      t.string :status, :default => 'new'

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
