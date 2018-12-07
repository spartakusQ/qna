class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :body
      t.t.boolean :correct
      t.t.integer :question_id

      t.timestamps
    end
  end
end
