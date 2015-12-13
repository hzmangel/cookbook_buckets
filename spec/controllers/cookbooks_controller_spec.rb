require 'rails_helper'

RSpec.describe CookbooksController, type: :controller do
  describe '#create' do
    context 'when given valid params' do
      let(:cookbook_params) do
        { name: 'Cookbook 1', desc: 'Desc of Cookbook 1' }
      end

      let(:materials_params) do
        [
          { name: 'material_1', quantity: 100, unit: 'g' },
          { name: 'material_2', quantity: 10, unit: 'cm' }
        ]
      end

      let(:tags_params) do
        [{ text: 'tag_1' }, { text: 'tag_2' }]
      end

      let(:params) do
        {
          cookbook: cookbook_params,
          materials: materials_params,
          tags: tags_params
        }
      end

      subject(:response) do
        post :create, params
      end

      it { expect { subject }.to change(Cookbook, :count).by(1) }
      it { expect { subject }.to change(Material, :count).by(2) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(2) }
      it { expect(subject.status).to eq 201 }
    end
  end

  describe '#update' do
    let(:cookbook) { FactoryGirl.create(:cookbook) }

    before(:each) do
      cookbook.reload
    end

    context 'when adding materials' do
      let(:materials_params) do
        JSON.parse(cookbook.materials.to_json)
          .append(name: 'NewAddedMaterial',
                  quantity: 20,
                  unit: 'kg')
      end

      subject(:response) do
        patch :update, id: cookbook.id,
                       cookbook: JSON.parse(cookbook.to_json),
                       tags: JSON.parse(cookbook.tags.to_json),
                       materials: materials_params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.to change(Material, :count).by(1) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(1) }
      it { expect(subject.status).to eq 200 }
    end

    context 'when adding materials w/ same name' do
      let(:materials_params) do
        JSON.parse(cookbook.materials.to_json)
          .append(name: 'NewAddedMaterial',
                  quantity: 20,
                  unit: 'kg')
          .append(name: 'NewAddedMaterial',
                  quantity: 10,
                  unit: 'kg')
      end
      subject(:response) do
        patch :update, id: cookbook.id,
                       cookbook: JSON.parse(cookbook.to_json),
                       tags: JSON.parse(cookbook.tags.to_json),
                       materials: materials_params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.to change(Material, :count).by(1) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(2) }
      it { expect(subject.status).to eq 200 }
    end

    context 'when update materials' do
      let(:materials_params) do
        materials_json = JSON.parse(cookbook.materials.to_json)
        materials_json.first[:name] = 'ChangeMaterialName'
        materials_json
      end

      subject(:response) do
        patch :update, id: cookbook.id,
                       cookbook: JSON.parse(cookbook.to_json),
                       tags: JSON.parse(cookbook.tags.to_json),
                       materials: materials_params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.to change(Material, :count).by(1) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(0) }
      it { expect(subject.status).to eq 200 }
      it { expect { subject }.to change(Material.where(name: 'ChangeMaterialName'), :count).by(1) }
    end

    context 'when removing materials' do
      let(:materials_params) do
        materials_json = JSON.parse(cookbook.materials.to_json)
        materials_json.first[:_destroy] = true
        materials_json
      end

      subject(:response) do
        patch :update, id: cookbook.id,
                       cookbook: JSON.parse(cookbook.to_json),
                       tags: JSON.parse(cookbook.tags.to_json),
                       materials: materials_params
      end

      it { expect { subject }.not_to change(Cookbook, :count) }
      it { expect { subject }.not_to change(Material, :count) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(-1) }
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
      it { expect { subject }.not_to change(Material, :count) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(-5) }
      it { expect(subject.status).to eq 204 }
    end
  end
end
