class ApiKey < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true

  before_validation :generate_token, on: :create

  scope :active, -> { where(active: true) }

  private

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end
end
