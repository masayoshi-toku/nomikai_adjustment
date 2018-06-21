require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  describe "GET #new" do
    subject { get :new }
    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: {id: id} }
    let(:reaction) { create(:reaction) }

    context "回答が存在する場合" do
      let(:id) { reaction.id }
      it { is_expected.to be_successful }
    end

    context "回答が存在しない場合" do
      let(:id) { reaction.id + 1 }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "POST #create" do
    subject { post :create, params: { reaction: attributes } }
    let(:reaction) { build(:reaction) }

    context "正しい値の場合" do
      let(:attributes) { reaction.attributes }
      it { expect{ subject }.to change{ Reaction.count }.by(1) }

      it "イベント詳細ページへリダイレクトする" do
        event = reaction.event
        expect(subject).to redirect_to event
      end
    end

    context "不正な値の場合" do
      let(:attributes) { reaction.attributes.merge(status: 10) }

      it { is_expected.to render_template(:new) }
    end
  end

  describe "PUT #update" do
    subject { put :update, params: { id: id, reaction: attributes } }
    let(:reaction) { create(:reaction) }

    context "回答が存在する場合" do
      let(:id) { reaction.id }

      context "正しい値の場合" do
        let(:attributes) { reaction.attributes.merge(status: 2) }
        let(:event) { reaction.event }
        before { subject }

        it "回答の更新が成功する" do
          reaction.reload
          updated_reaction = Reaction.find_by(id: reaction.id)
          expect(updated_reaction.status).to eq 2
        end

        it { is_expected.to redirect_to event }
      end

      context "不正な値の場合" do
        before { subject }
        let(:attributes) { reaction.attributes.merge(status: 10) }

        it { is_expected.to render_template(:edit) }
      end
    end

    context "存在しない場合" do
      let(:id) { 10 }
      let(:attributes) { reaction.attributes.merge(status: 2) }
      it { is_expected.to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { id: id } }
    before { reaction }
    let(:reaction) { create(:reaction) }
    let(:event) { reaction.event }

    context "回答が存在する場合" do
      let(:id) { reaction.id }
      it { expect{ subject }.to change{ Reaction.count }.by(-1) }
      it { is_expected.to redirect_to event }
    end

    context "回答が存在しない場合" do
      let(:id) { 10 }
      it { is_expected.to redirect_to root_url }
    end
  end
end
