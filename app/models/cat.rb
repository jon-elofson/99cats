class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :sex, inclusion: { in: ['M','F'] }
  validates :color, inclusion: { in: ['black','white','grey','orange','calico'] }

  has_many(
    :rental_requests,
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy,
    class_name: :CatRentalRequest
  )

  def age
    ((Time.now - birth_date) / (60*60*24*365)).to_i
  end
end
