require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:event_date) { create(:event_date, event: event) }
  let(:reaction) { create(:reaction, user: user, event_date: event_date) }

  describe "GET #new" do
    subject { get :new, params: { event_url_path: url_path } }
    let(:url_path) { event.url_path }
    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: { event_url_path: url_path } }

    context "イベントが存在する場合" do
      let(:url_path) { event.url_path }
      it { is_expected.to be_successful }
    end

    context "イベントが存在しない場合" do
      let(:url_path) { '' }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "POST #create" do
    subject { post :create, params: { reaction_form: attributes, event_url_path: event.url_path } }

    before do
      event_date
      log_in(user)
    end

    context "正しい値の場合" do
      let(:attributes) { { answer: { "#{event_date.id}": '3' } } }
      it { expect{ subject }.to change{ Reaction.count }.by(1) }

      it "イベント詳細ページへリダイレクトする" do
        event_url_path = event.url_path
        expect(subject).to redirect_to event_path(event_url_path)
      end
    end

    context "不正な値の場合" do
      let(:attributes) { { answer: { "#{event_date.id}": '10' } } }

      it { is_expected.to redirect_to new_event_reactions_url(event.url_path) }
    end
  end
end
