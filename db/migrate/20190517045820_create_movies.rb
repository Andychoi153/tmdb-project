class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies, :id => false do |t|
      t.primary_key :movie_id, :null => false
      t.string :title
      t.string :poster_path
      t.float :vote_average
      t.integer :vote_count

      t.timestamps
    end
  end
end
