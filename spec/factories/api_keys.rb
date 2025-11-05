FactoryBot.define do
  factory :api_key do
    token { "MyString" }
    name { "MyString" }
    active { false }
  end
end
