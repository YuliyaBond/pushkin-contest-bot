class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.string :question
      t.string :answer
      t.decimal :task_id
      t.decimal :level
      

      t.timestamps
    end
  end
end
