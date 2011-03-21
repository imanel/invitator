class AddTokenToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :token, :string
    Invitation.all.each do |invitation|
      invitation.generate_token
      invitation.save(:validate => false)
    end
  end

  def self.down
    remove_column :invitations, :token
  end
end
