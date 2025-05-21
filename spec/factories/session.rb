FactoryBot.define do
  factory :session do
    sequence(:name) { |n| "Candidate #{n}" }
    token { SecureRandom.uuid }
  end
end
