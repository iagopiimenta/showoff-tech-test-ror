class User
  include ActiveModel::Model
  include ShowoffApiResource

  attr_accessor :access_token

  attribute :id, :integer
  attribute :name, :string
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :password, :string
  attribute :email, :string
  attribute :image_url, :string
  attribute :active, :boolean
  attribute :date_of_birth, :datetime

  attr_reader :images, :token

  validates :password, presence: true, on: :create
  validates :first_name, :last_name, :email, presence: true
  validates :password, length: { minimum: 8 }, on: :create

  def self.me
    find('me')
  end

  def images=(images)
    @images = images.is_a?(Image) ? images : Image.new(images)
  end

  def create!
    create(
      client_id: Authentication.oauth2_client&.id,
      client_secret: Authentication.oauth2_client&.secret,
      user: {
        first_name: first_name,
        last_name: last_name,
        password: password,
        date_of_birth: date_of_birth&.to_i,
        email: email,
        image_url: image_url
      }
    )
  end

  def update!
    update(
      id,
      user: {
        first_name: first_name,
        last_name: last_name,
        date_of_birth: date_of_birth&.to_i,
        image_url: image_url,
      }
    )
  end

  def token=(data)
    if data.is_a?(Hash) && Authentication.oauth2_client
      @token = OAuth2::AccessToken.from_hash(Authentication.oauth2_client, data)
    else
      @token = data
    end
  end

  def ==(other)
    self.class == other.class && self.id == other.id
  end
end
