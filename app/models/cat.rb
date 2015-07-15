# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :datetime         not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image_name  :string
#

# require_relative '../uploaders/cat_picture_uploader'

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
