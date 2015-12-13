FactoryGirl.define do
  factory :material_quantities, class: 'MaterialQuantity' do
    quantity 100
    unit 'g'

    material
    cookbook
  end
end
