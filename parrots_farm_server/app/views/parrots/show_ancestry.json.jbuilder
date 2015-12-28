json.array!(@ancestry) do |parrot|
  json.extract! parrot, :id, :name, :age, :sex, :color, :brood
end