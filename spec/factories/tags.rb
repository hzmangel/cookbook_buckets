FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Material_#{n}" }
  end
end
