Factory.define :user do |f|
  f.sequence(:login) {|n| "user#{n}" }
  f.password "secret"
  f.password_confirmation {|user| user.password}
end

Factory.define :profile do |f|
  f.association :user
  f.full_name 'Some Name'
  f.address 'Some Address'
end