FactoryBot.define do
  factory :invoice do
    customer
    finalized { false }
    paid { false }
    date { Date.current }
  end
end
