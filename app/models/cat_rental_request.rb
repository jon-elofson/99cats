class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: ["PENDING","APPROVED","DENIED"] }
  validate :has_overlapping_approved_requests
  #after_initialize status ||= "PENDING"

  belongs_to(
    :cat,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: :Cat
  )

  def overlapping_requests
    CatRentalRequest.where(cat_id: cat_id)
      .where("id != ?", id)
      .where("start_date BETWEEN ? AND ?", start_date, end_date)
      .where("end_date BETWEEN ? AND ?", start_date, end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

  def has_overlapping_approved_requests
    if overlapping_approved_requests.length > 0 && status == "APPROVED"
      errors[:request] << "Can't have overlapping approved requests"
    end
  end

  def pending?
    status == "PENDING"
  end

  def approve!
    transaction do
      self.status = "APPROVED"
      save!
      overlapping_pending_requests.each { |request| request.deny! }
    end
  end

  def deny!
    self.status = "DENIED"
    save!
  end
end
