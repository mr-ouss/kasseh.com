class Article < ApplicationRecord
  # Active Storage
  has_one_attached :featured_image

  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :content, presence: true

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_validation :calculate_reading_time, if: -> { content.present? }
  before_validation :generate_excerpt, if: -> { excerpt.blank? && content.present? }

  # Scopes
  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current).order(published_at: :desc) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(published_at: :desc).limit(5) }

  # Class methods
  def self.by_year
    published.group_by { |article| article.published_at.year }
  end

  # Instance methods
  def published?
    published_at.present? && published_at <= Time.current
  end

  def to_param
    slug
  end

  def formatted_date
    published_at&.strftime("%B %d, %Y")
  end

  private

  def generate_slug
    self.slug = title.downcase.gsub(/[^a-z0-9\s-]/, "").gsub(/\s+/, "-").gsub(/-+/, "-").strip
  end

  def calculate_reading_time
    # Average reading speed: 200 words per minute
    words = content.split.size
    self.reading_time = (words / 200.0).ceil
  end

  def generate_excerpt
    # Take first 200 characters of content, stripping HTML if present
    plain_text = content.gsub(/<[^>]*>/, "")
    self.excerpt = plain_text.truncate(200, separator: " ", omission: "...")
  end
end
