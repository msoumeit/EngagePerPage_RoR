json.array!(@puzzles) do |puzzle|
  json.extract! puzzle, :id, :name, :ptype, :content, :winrules, :hintbox
  json.url puzzle_url(puzzle, format: :json)
end
