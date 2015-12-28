json.array!(@parrots) do |parrot|
  json.extract! parrot, :id, :name, :age, :sex, :color, :brood
end
