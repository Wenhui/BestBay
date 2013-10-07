# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bid do
    user_id 1
    item_id 1
    price 100
  end
end
