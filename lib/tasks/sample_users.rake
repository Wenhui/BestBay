#This file populates the development database with fake users and items. It is executed when the command rake db:all is run
namespace :db do
  desc "Fill database with sample users"
  task populate: :environment do

    [Item, User].each(&:delete_all)
    #Create Admin
    ad=User.create!(userName: "Admin",
                 email: "admin@sv.cmu.edu",
                 password: "123456",
                 password_confirmation: "123456",
                 address: "Mountain View",
                 birthdate: "10/10/1984",
                 card_number: "1111111111111111",
                 expiration_date: "10/10/2013",
                 security_num:    "123",
                 )
    ad.toggle!(:admin)
    ad.save!
    #Create 20 regular users
    20.times do |n|
      userName=Faker::Name.name
      email=Faker::Internet.email(name=nil)
      password="123456"
      password_confirmation=password
      address=Faker::Address.street_address(include_secondary=true)
      birthdate="10/10/1984"
      card_number="1111111111111111"
      expiration_date="10/10/2013"
      security_num="123"
      @user=User.create!(userName: userName,
                   email: email,
                   password: password,
                   password_confirmation: password_confirmation,
                   address: address,
                   birthdate: birthdate,
                   card_number: card_number,
                   expiration_date: expiration_date,
                   security_num:    security_num
      )

      #For each user, post 5 items (i.e. start 5 auctions)
      5.times do |k|
        itemName=Faker::Lorem.words(1)
        description=Faker::Lorem.paragraph(sentence_count=1+rand(30), supplemental=false)
        start_price=100*rand
        reserve_price=start_price +50*rand
        auction_end=DateTime.now+rand(200).hours+1
        category= Category.all[rand(Category.count)]

        @item=@user.items.create!(
            name: itemName,
            description: description,
            start_price: start_price,
            reserve_price: reserve_price,
            auction_end: auction_end
        )
        category.items << @item
      end
    end

    #Generate 200 watched items for 200 users randomly;
    200.times do
      offset = rand(User.count)
      rand_record = User.first(:offset => offset)

      offset2 = rand(Item.count)
      rand_record_item = Item.first(:offset => offset2)

      while rand_record.items.include?(rand_record_item) do
        offset2 = rand(Item.count)
        rand_record_item = Item.first(:offset => offset2)
      end

      Watch.create!(user_id: rand_record.id, item_id: rand_record_item.id)

      rand_record_item.user.rate(1+rand(5),rand_record,:rating)
    end

    #Randomly generate 1000 bids. (A randomly chosen user bids on a randomly chosen item)
    1000.times do

      offset = rand(User.count)
      rand_user = User.first(:offset => offset)

      offset2 = rand(Item.count)
      rand_record_item = Item.first(:offset => offset2)

      while rand_user.items.include?(rand_record_item) do
        offset2 = rand(Item.count)
        rand_record_item = Item.first(:offset => offset2)
      end

      price=rand(max=100)
      if rand_record_item.bidders.empty?
        price=price + rand_record_item.start_price
        Bid.create!(user_id: rand_user.id, item_id: rand_record_item.id, price: price)
        rand_record_item.highest_price=price
      else
        price=price+rand_record_item.bids.first.price
        rand_record_item.bids.find_or_create_by_user_id(user_id: rand_user.id, price: price)
        rand_record_item.highest_price=price
      end


    end

    #Generate 1000 random comments on 1000 random items
    1000.times do

      offset = rand(User.count)
      rand_user = User.first(:offset => offset)

      offset2 = rand(Item.count)
      rand_record_item = Item.first(:offset => offset2)

      Comment.create!(user_id: rand_user.id, item_id: rand_record_item.id, content: Faker::Lorem.characters(char_count=rand(1..140)) )

    end
    #Load a random image for each item from app/assets/images
    Item.all.each{ |item| item.picture = File.open(Dir.glob(File.join(Rails.root, '/app/assets/images', '*')).sample); item.save}
  end
end