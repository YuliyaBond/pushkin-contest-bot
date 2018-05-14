require 'json'

class FilePushkin
  def parse
    file = File.read('./db/pushkin_poems.json')
    JSON.parse(file)
  end
end