class Restaurant < ActiveRecord::Base
  include AsUserAssociationExtension

  has_many :reviews, -> { extending WithUserAssociationExtension }, dependent: :destroy

  validates :name, length: { minimum: 3 }, uniqueness: true
  validates_presence_of :user
  belongs_to :user

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def average_rating
    reviews.none? ? 'N/A' : reviews.average(:rating)
  end

end
