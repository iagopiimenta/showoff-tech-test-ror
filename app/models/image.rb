class Image
  include ActiveModel::Model

  attr_accessor :small_url, :medium_url, :large_url, :original_url
end
