class Widget
  include ShowoffApiResource

  module Kinds
    VISIBLE = 'visible'.freeze
    HIDDEN = 'hidden'.freeze
  end

  attr_reader :user

  attribute :id, :integer
  attribute :name, :string
  attribute :description, :string
  attribute :kind, :string
  attribute :owner, :boolean

  validates :id, presence: true, on: :update
  validates :kind, inclusion: { in: [Kinds::VISIBLE, Kinds::HIDDEN] }
  validates :owner, inclusion: { in: [true, false] }, allow_blank: true
  validates :name, :description, presence: true

  def user=(user)
    @user = user.is_a?(User) ? user : User.new(user)
  end

  def self.only_visible(term = nil)
    all(
      path: "#{plural_name}/visible",
      params: { term: term },
      include_query_credentials: true,
      # skip_access_token: true
    )
  end

  def self.by_user_id(id, term = nil)
    all(
      path: "users/#{id}/#{plural_name}",
      params: { term: term },
      include_query_credentials: true,
    )
  end

  def self.own_widgets(term = nil)
    by_user_id('me', term)
  end

  def create!
    create(
      widget: {
        name: name,
        description: description,
        kind: kind
      }
    )
  end

  def update!
    update(
      id,
      widget: {
        name: name,
        description: description,
        kind: kind
      }
    )
  end
end
