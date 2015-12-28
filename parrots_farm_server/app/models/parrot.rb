class Parrot
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include Filterable
  extend Enumerize

  belongs_to :mother, class_name: "Parrot", :foreign_key => "mother_id"
  belongs_to :father, class_name: "Parrot", :foreign_key => "father_id"

  field :name, type: String
  field :age, type: Integer, default: 0

  field :sex
  enumerize :sex, in: [:male, :female], default: :male
  field :color
  enumerize :color, in: [:green, :blue, :yellow, :white], default: :green

  field :brood, type: Boolean, default: false

  validates :sex, presence: true
  validates :color, presence: true
  validates :age, presence: true

  scope :id, -> (id) {where id: id}
  scope :search_name, -> (search_name) {where name: search_name}
  scope :age_equal, -> (age) {where age: age}
  scope :age_gt, -> (age) {where(:age.gt => age)}
  scope :age_lt, -> (age) {where(:age.lt => age)}
  scope :sex_is, -> (sex_value) {where sex: sex_value}
  scope :color_is, -> (color_value) {where color: color_value}
  scope :brood, -> (brood) {where brood: brood}
  

  def children
    sex.female? ? Parrot.where(mother: self).all : Parrot.where(father: self).all.to_a
  end

  def has_children
    children.count > 0
  end

  def parents
    [mother, father]
  end

  def has_parents
    mother.present? && father.present?
  end

  def descendants #массив всех потомков
    array_of_descendants = []

    if children.count > 0
      for child in children do
        array_of_descendants << child
        array_of_descendants += child.descendants  
      end
    end

    return array_of_descendants
  end

  def ancestry #массив всех предков
    array_of_ancestry = []
    if has_parents
      logger.debug "current #{self.name} #{self.parents}"
      for parent in parents
        array_of_ancestry << parent
        array_of_ancestry += parent.ancestry
      end
    end
    return array_of_ancestry
  end

  def valid_parents
    return mother.if_valid_mother && father.if_valid_father && parents_same_color && not_parent_of_itself && has_no_parents_as_children
  end

  def has_no_parents_as_children
    if parents_are_not_children_of_itself_child
      return true
    else
      self.errors.add(:base, "Parent can't be child of itself children")
      return false
    end
  end

  def parents_are_not_children_of_itself_child
    if self.sex.male?
      (mother.father ? mother.father.id != self.id : true) && (father.father ? father.father.id != self.id : true)
    else
      (mother.mother ? mother.mother.id != self.id : true) && (father.mother ? father.mother.id != self.id : true)
    end
  end

  def not_parent_of_itself
    if mother.id != self.id && father.id != self.id
      return true
    else
      self.errors.add(:base, "Parrot can't be parent of itself")
      return false
    end
  end

  def if_valid_mother
    if valid_parent && sex.female?
      return true
    else
      self.errors.add(:base, "Parrot isn't valid to be a mother")
      return false
    end
  end

  def if_valid_father
    if valid_parent && sex.male?
      return true
    else
      self.errors.add(:base, "Parrot isn't valid to be a father")
      return false
    end
  end

  def valid_parent
    brood && is_grown_up
  end

  def is_grown_up
    age >= 12
  end

  def parents_same_color
    if mother.color == father.color
      return true
    else
      self.errors.add(:base, "Parents haven't same color")
      return false
    end
  end

  def can_make_pair_with
    Parrot.where(color: self.color, :age.gte => 12, brood: true, :sex.ne => self.sex).all
  end

  def self.candidates_to_parent(sex)
    Parrot.where(sex: sex, :age.gte => 12, brood: true).all
  end

  before_create :generate_name
  before_save :check_parents
  before_update :check_children_for_update
  before_destroy :check_children_for_remove

  private
    def check_parents
      count_of_parents = 0
      count_of_parents += mother? ? 1 : 0
      count_of_parents += father? ? 1 : 0

      case count_of_parents
      when 0
        return true #допустим, что попугайчик может быть сиротой по техническим причинам
      when 1
        self.errors.add(:base, "Parrot can't have one parent")
        return false
      when 2
        self.valid_parents
      end
    end

    def check_children_for_update
      if has_children
        if valid_parent
          return true
        else
          self.errors.add(:base, "Parrot with children should be a valid parent")
          return false  
        end
      else
        return true
      end
    end

    def check_children_for_remove
      if !has_children
        logger.debug "allow to remove"
        return true
      else
        self.errors.add(:base, "Parrot with children can't be removed")
        return false
      end
    end

    def generate_name 
      self.name = sex.male? ? Parrot.get_male_name : Parrot.get_female_name
    end

    def self.get_male_name
      return ["Кеша", "Жора", "Жак", "Яша", "Арчи", "Гриша", "Кирюша", "Карлуша"].sample
    end

    def self.get_female_name
      return ["Даша", "Жанна", "Даша", "Маша", "Ксюша", "Жужа", "Тиша", "Чуча"].sample
    end
end
