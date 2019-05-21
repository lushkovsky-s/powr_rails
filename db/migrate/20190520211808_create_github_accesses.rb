class CreateGithubAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :github_accesses do |t|
      t.string :access_token
      t.string :github_id
      t.string :name
      t.string :login
      t.string :avatar_url
      t.string :bio
      t.string :location
      t.string :company
      t.timestamp :created_at

      t.timestamps
    end
  end
end
