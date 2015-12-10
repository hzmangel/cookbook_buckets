FactoryGirl.define do
  factory :cookbook do
    sequence(:name) { |n| "Cookbook_#{n}" }
    sequence(:desc) { |n| "Cookbook desc #{n}" }

    transient do
      materials_count 5
    end

    after(:create) do |cookbook, evaluator|
      create_list(:material, evaluator.materials_count, cookbook: cookbook)
    end
  end
end
