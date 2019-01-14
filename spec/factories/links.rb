FactoryBot.define do
  factory :link do
    name { "github" }
    url { "https://github.com/" }
  end

  trait :gist_link do
    name { "Gist" }
    url { "https://gist.github.com/spartakusQ/c233d40da8000b73c72d54cd7ebd1f1a" }
  end

end
