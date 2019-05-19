class CreateTvs < ActiveRecord::Migration[5.2]
  def change
    create_table :tvs, :id => false  do |t|
      t.primary_key :tv_id, :null => false
      t.string :name
      t.string :poster_path
      t.float :vote_average
      t.integer :vote_count

      t.timestamps
    end
  end
end
