json.array!(@descendants) do |parrot|
  json.extract! parrot, :id, :name, :age, :sex, :color, :brood
end