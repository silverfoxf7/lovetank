

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    
    Rake::Task['db:reset'].invoke
    make_users
    make_jobposts
    make_bids
    make_microposts
    make_relationships
    make_winationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar",
                       :real_name => "Joe Vasquez",
                 :status => 1,
                 :skills => "Spanish, Document Reviews, Patents",
                 :location => "New York, NY",
                 :rating => 999,
                 :jobs_completed => 32,
                 :tagline => "Ivy League, former Big Law attorney,
                              Patent litigator",
                 :skill1 => "Patent Litigation",
                 :skill2 => "Electrical Engineering",
                 :skill3 => "Spanish Speaker",
                 :resume => Faker::Lorem.paragraph(5),
                 :account_type => 1)

  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Lorem.words(2)  # refers to USERNAME
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    real_name   = Faker::Name.name   # is the REAL name
    location    = Faker::Lorem.sentence(1) 
    status      = rand(2) # available = 1;  not-available = 0
    skills =    Faker::Lorem.paragraph(5) 
    rating =  (1 + rand(1000))   # is 1000/100
    jobs_completed = rand(50)
    tagline = Faker::Lorem.paragraph(2)
    skill1 = Faker::Lorem.sentence(1)
    skill2 = Faker::Lorem.sentence(1)
    skill3 = Faker::Lorem.sentence(1)
    resume = Faker::Lorem.paragraph(6)
    account_type = (1 + rand(4))

    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password,
                 :real_name => real_name,
                 :status => status,
                 :skills => skills,
                 :location => location,
                 :rating => rating,
                 :jobs_completed => jobs_completed,
                 :tagline => tagline,
                 :skill1 => skill1,
                 :skill2 => skill2,
                 :skill3 => skill3,
                 :resume => resume,
                 :account_type => account_type)
  end
end

def make_jobposts
  User.all(:limit => 30).each do |user|
    2.times do
      title       = Faker::Lorem.sentence(1) # => "Big Document Review Project",
      email       = "#{Faker::Lorem.words(1)}@foo.com"
      location    = Faker::Lorem.sentence(1) #=> "New York, NY",
      poster      = user.name #=> the name of the user with user_id,
      description = Faker::Lorem.paragraph(5) #=> "This is a document review project.",
      var_work_type   = (1 + rand(3))   # 1 refers to doc review
      work_type = case var_work_type
        when 1 then "Document Review"
        when 2 then "Legal Research"
        else "Drafting Patent"
      end
      max_budget  = (1 + rand(100))  # generate random number between $1-100
      duration   = (1 + rand(100))  # generates 1-100 day projects
      var_skills      = (1 + rand(4))
      skills = case var_skills
        when 1 then "Spanish"
        when 2 then "Japanese"
        when 3 then "Patent"
        else ""
      end
      start_date          = rand_time(5.days.from_now, 5.weeks.from_now)
      overtime            = [true,false][rand(2)]
      work_intensity      = (1 + rand(100))

      user.jobposts.create!(
                  :title       => title,
                  :location    => location,
                  :poster      => poster,
                  :description => description,
                  :work_type   => work_type,
                  :max_budget  => max_budget,
                  :duration   => duration,
                  :skills      => skills,
                  :start_date  => start_date,
                  :overtime    => overtime,
                  :work_intensity => work_intensity,
                  :email       => email)
    end
  end
end

def make_bids
  User.all(:limit => 30).each do |user|
    2.times do
      amount       = (1 + rand(100))   # sets a bid amount
      jobpost_id   = (1 + rand(59))  # should set IDs between 1 to 59

      user.bids.create!(
                  :amount       => amount,
                  :jobpost_id   => jobpost_id)
    end
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_winationships
  users = User.all
  winners = users[1..10]
  job = Jobpost.find(60)
  winners.each { |worker| job.pick_winner!(worker) }
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

def rand_time(from, to)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
end