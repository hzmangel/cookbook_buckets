require 'rails_helper'

RSpec.describe CookbooksController, type: :controller do
  describe '#create' do
    context 'when given valid params' do
      let(:valid_params) do
        {
          cookbook: {
            name: 'Cookbook_1',
            desc: 'Desc of Cookbook_1',
            materials_attributes: [{
              name: 'material_1',
              quantity: 100,
              unit: 'g'
            }, {
              name: 'material_2',
              quantity: 10,
              unit: 'cm'
            }],
            tags_attributes: [{ name: 'tag_1' }, { name: 'tag_2' }]
          }
        }
      end

      subject(:response) do
        post :create, valid_params
      end

      it { expect { response }.to change(Cookbook, :count).by(1) }
      it { expect { response }.to change(Material, :count).by(2) }
      it { expect(response.status).to eq 201 }
    end
  end

  describe '#update' do
    context 'when added materials' do
    end
  end
end
