# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => 'User' do
   sequence(:userName) {|n| "Test User#{n}" }
   sequence(:email) {|n| "weristdas#{n}@ger.com"}
   password "123456"
   password_confirmation  "123456"
   address  "Mountain View"
   birthdate '2001-02-03'
   card_number  "1"*16
   security_num "111"
   expiration_date '2001-02-03'
  end


  factory :item do
    sequence(:name) {|n| "Test Dog#{n}" }
    description "This is a dog"
    start_price 1.5
    reserve_price 1.5
    auction_end DateTime.now+1.hour
    user 
  end


    factory :admin, :class => 'User' do
      admin true
      userName "kuangchenkai"
      email "kck@kck.com"
      password "123456"
      password_confirmation  "123456"
      address  "Mountain View"
      birthdate '2001-02-03'
      card_number  "1"*16
      security_num "111"
      expiration_date '2001-02-03'
    end


end
