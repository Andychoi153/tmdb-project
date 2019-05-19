class CreateTvCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_credits, :id => false do |t|
      t.references :tv
      t.references :person
      t.integer :season_number
      t.integer :episode_number
      t.string :role

      t.timestamps
    end
    add_index :tv_credits, [:tv_id, :season_number, :episode_number, :person_id], :unique => true, :name => :tv_episode_person_match
  end
end
