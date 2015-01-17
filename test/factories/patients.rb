FactoryGirl.define do
  factory :patient do
    given_name 'John'
    family_name 'Doe'
    gender 'M'
    birthdate { 30.years.ago }
  end
end
