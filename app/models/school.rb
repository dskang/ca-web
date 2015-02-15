class School < ActiveRecord::Base
  has_many :users

  validates :name, presence: true, uniqueness: true

  def proper_name
    case name
    when "upenn"
      "Penn"
    else
      name.titleize
    end
  end

  # use the name as the slug
  # https://gist.github.com/cdmwebs/1209732
  def to_param
    name.parameterize
  end
end
