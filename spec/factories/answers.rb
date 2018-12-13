FactoryBot.define do
  sequence :body do |n|
    "Some one #{n}"
  end

  factory :answer do
    body
    question

    trait :invalid do
      body { nil }
    end
  end
end
