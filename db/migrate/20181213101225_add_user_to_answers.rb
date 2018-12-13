class AddUserToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, foreign_key: true, null: false
    remove_column :answers, :correct
  end
end
