require 'rails_helper'

RSpec.describe CookbooksController, type: :controller do
  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe '#create' do
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

    context 'when given valid params' do
      subject(:response) do
        post :create, params
      end

      it { expect { subject }.to change(Cookbook, :count).by(1) }
      it { expect { subject }.to change(Material, :count).by(2) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(2) }
      it { expect(subject.status).to eq 201 }
    end

    context 'when given duplicated tag name' do
      subject(:response) do
        post :create, params
        post :create, params
      end

      it { expect { subject }.to change(Cookbook, :count).by(2) }
      it { expect { subject }.to change(Material, :count).by(2) }
      it { expect { subject }.to change(MaterialQuantity, :count).by(4) }
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

  describe '#search' do
    let(:cookbooks) { FactoryGirl.create_list(:cookbook, 5) }
    let(:tags) { FactoryGirl.create_list(:tag, 5) }

    before(:each) do
      cookbooks[0].update(tags: tags[0..1])
      cookbooks[1].update(tags: tags[1..2])
      cookbooks[2].update(tags: tags[2..3])
      cookbooks[3].update(tags: tags[3..4])
      cookbooks[4].update(tags: tags[0..5])
    end

    context 'when given cookbook name' do
      let(:q) do
        { cookbook_name: cookbooks[0].name }
      end

      subject(:response) do
        post :search, searchParams: q
      end

      it { expect(subject.status).to eq 200 }

      it 'only returns cookbook 1' do
        subject
        expect(assigns(:rcds).count).to eq 1
        expect(assigns(:rcds).first.name).to eq 'Cookbook_1'
      end
    end

    context 'when given tag name' do
      let(:q) do
        { tag_name: tags.first.name }
      end

      subject(:response) do
        post :search, searchParams: q
      end

      it { expect(subject.status).to eq 200 }

      it 'returns cookbook 1 and 4' do
        subject
        expect(assigns(:rcds).count).to eq 2
        expect(assigns(:rcds).map(&:name)).to eq [cookbooks[0].name, cookbooks[4].name]
      end
    end
  end
end
