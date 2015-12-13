FactoryGirl.define do
  factory :material do
    sequence(:name) { |n| "Material_#{n}" }
  end
end
