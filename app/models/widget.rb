class Widget
  include ActiveModel::Model
  include ShowoffApiResource

  attr_accessor :id, :name, :description, :kind, :owner
  attr_reader :user

  module Kinds
    VISIBLE = 'visible'.freeze
    HIDDEN = 'hidden'.freeze
  end

  validates :kind, inclusion: { in: [Kinds::VISIBLE, Kinds::HIDDEN] }

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
