class CreateTvSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_seasons, :id => false do |t|
      t.references :tv
      t.integer :season_number
      t.string :poster_path

      t.timestamps
    end
    add_index :tv_seasons, [:tv_id, :season_number], :unique => true, :name => :tv_season_match
  end
end
