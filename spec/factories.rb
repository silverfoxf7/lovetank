Factory.define :user do |user|
  user.name                   "Rod Fuentes"
  user.email                  "joserodrigofuentes@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo Bar"
  micropost.association :user
end

Factory.define :jobpost do |jobpost|
  jobpost.title        "Foo Bar title"
  jobpost.location     "Foo Bar location"
  jobpost.poster       "Foo Bar poster"
  jobpost.description  "Foo Bar description"
  jobpost.work_type    1
  jobpost.max_budget   35
  jobpost.timeframe    Time.now
  jobpost.skills       1
  jobpost.association :user
end
