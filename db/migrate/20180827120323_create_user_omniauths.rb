class CreateUserOmniauths < ActiveRecord::Migration[5.2]
  def change
    create_table :user_omniauths do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :consumer_key
      t.string :consumer_secret
      t.string :access_token
      t.string :access_token_secret
      t.timestamps
    end
  end
end
