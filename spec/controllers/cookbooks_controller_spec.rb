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

      it { expect { subject }.to change(Cookbook, :count).by(1) }
      it { expect { subject }.to change(Material, :count).by(2) }
      it { expect(subject.status).to eq 201 }
    end
  end

  describe '#update' do
    let(:cookbook) { FactoryGirl.create(:cookbook) }

    before(:each) do
      cookbook.reload
    end

    context 'when adding materials' do
      let(:params) do
        {
          materials_attributes: [{
            name: 'NewAddedMaterial',
            quantity: 20,
            unit: 'kg'
          }]
        }
      end

      subject(:response) do
        patch :update, id: cookbook.id, cookbook: params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.to change(Material, :count).by(1) }
      it { expect(subject.status).to eq 200 }
    end

    context 'when removing materials' do
      let(:params) do
        {
          materials_attributes: [{
            id: cookbook.materials.first.id,
            _destroy: true
          }]
        }
      end

      subject(:response) do
        patch :update, id: cookbook.id, cookbook: params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.to change(Material, :count).by(-1) }
      it { expect(subject.status).to eq 200 }
    end
  end

  describe '#destroy' do
    let(:cookbook) { FactoryGirl.create(:cookbook) }
    before(:each) do
      cookbook.reload
    end

    context 'when given valid params' do
      subject(:response) do
        delete :destroy, id: cookbook.id
      end

      it { expect { subject }.to change(Cookbook, :count).by(-1) }
      it { expect { subject }.to change(Material, :count).by(-5) }
      it { expect(subject.status).to eq 204 }
    end
  end
end
