json.extract! quiz, :id, :question, :task_id, :level, :decimal, :answer, :created_at, :updated_at
json.url quiz_url(quiz, format: :json)
