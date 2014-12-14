FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name  'Doe'
    admin false
  end

  factory :admin, class: User do
    first_name 'Admin'
    last_name  'User'
    admin      true
  end
end
