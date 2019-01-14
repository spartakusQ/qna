class Link < ApplicationRecord
  GIST_URL = "gist.github.com"
  URL_VALID = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_VALID, message:'has invalid' }

  def gist?
    URI(url).host == GIST_URL
  end

  def gist_content
    client = Octokit::Client.new(access_token: ENV['GITHUB_SECRET_TOKEN'])
    gist = client.gist(url.split("/").last)
    file = {}
    gist.files.each { |_, v| file = v }
    file.content
  end
end
