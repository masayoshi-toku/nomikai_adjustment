require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:event_date) { create(:event_date) }
  let(:reaction) { create(:reaction) }

  describe "GET #new" do
    subject { get :new, params: { url_path: url_path } }
    let(:event) { create(:event) }
    let(:url_path) { event.url_path }
    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: {id: id} }

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
    subject { post :create, params: { reaction_form: attributes } }

    before do
      event_date
      log_in(user)
    end

    context "正しい値の場合" do
      let(:attributes) { { event_url_path: event_date.event.url_path, status: { "#{event_date.id}": '3' } } }
      it { expect{ subject }.to change{ Reaction.count }.by(1) }

      it "イベント詳細ページへリダイレクトする" do
        event_url_path = event_date.event.url_path
        expect(subject).to redirect_to event_path(event_url_path)
      end
    end

    context "不正な値の場合" do
      let(:attributes) { { event_url_path: event_date.event.url_path, status: { "#{event_date.id}": '10' } } }

      it { is_expected.to redirect_to new_reaction_url(url_path: event_date.event.url_path) }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { id: id } }
    before { reaction }
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
