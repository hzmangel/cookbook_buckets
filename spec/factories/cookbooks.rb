FactoryGirl.define do
  factory :cookbook do
    sequence(:name) { |n| "Cookbook_#{n}" }
    sequence(:desc) { |n| "Cookbook desc #{n}" }

    transient do
      materials_count 5
    end

    after(:create) do |cookbook, evaluator|
      evaluator.materials_count.times do
        material = FactoryGirl.create(:material)
        FactoryGirl.create(:material_quantities, cookbook: cookbook, material: material)
      end
    end
  end
end
