class CreateTvEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_episodes, :id => false do |t|
      t.references :tv
      t.integer :season_number
      t.integer :episode_number
      t.string :still_path
      t.float :vote_average
      t.integer :vote_count

      t.timestamps
    end
    add_index :tv_episodes, [:tv_id, :season_number, :episode_number], :unique => true, :name => :season_episode_match
    add_index :tv_episodes, [:tv_id, :episode_number], :unique => false, :name => :tv_episode_match
  end
end
