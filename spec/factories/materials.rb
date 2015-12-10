FactoryGirl.define do
  factory :material do
    sequence(:name) { |n| "Material_#{n}" }
    quantity 100
    unit 'g'

    cookbook
  end
end
