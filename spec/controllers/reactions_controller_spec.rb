require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:event_date) { create(:event_date, event: event) }
  let(:reaction) { create(:reaction, user: user, event_date: event_date) }

  describe "GET #new" do
    before { log_in(user) }
    subject { get :new, params: { event_url_path: url_path } }
    let(:url_path) { event.url_path }
    it { is_expected.to be_successful }
  end

  describe "GET #edit" do
    subject { get :edit, params: { event_url_path: url_path } }

    context "ログイン済みの場合" do
      before { log_in(user) }

      context "イベントが存在する場合" do
        let(:url_path) { event.url_path }
        it { is_expected.to be_successful }
      end

      context "イベントが存在しない場合" do
        let(:url_path) { '' }
        it { is_expected.to redirect_to root_path }
      end
    end

    context "ログインしていない場合" do
      let(:url_path) { event.url_path }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "POST #create" do
    subject { post :create, params: { reaction_form: attributes, event_url_path: event.url_path } }
    before { event_date }

    context "ログイン済みの場合" do
      before { log_in(user) }

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

    context "ログインしていない場合" do
      let(:attributes) { { answer: { "#{event_date.id}": '3' } } }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "PUT #update" do
    before { reaction }

    context "ログイン済みの場合" do
      before do
        log_in(user)
        put :update, params: { reaction_form: attributes, event_url_path: event.url_path }
      end

      context "正しい値の場合" do
        before { old_status }
        let(:old_status) { reaction.status }
        let(:attributes) { { answer: { "#{event_date.id}": '3' } } }
        let(:updated_reaction) { Reaction.find_by(id: reaction.id) }

        it :aggregate_failures do
          expect(updated_reaction.status).not_to eq old_status
          expect(updated_reaction.status).to eq 3
        end

        it "イベント詳細ページへリダイレクトする" do
          event_url_path = event.url_path
          expect(response).to redirect_to event_path(event_url_path)
        end
      end

      context "不正な値の場合" do
        let(:attributes) { { answer: { "#{event_date.id}": '10' } } }

        it { is_expected.to redirect_to edit_event_reactions_path(event.url_path) }
      end
    end

    context "ログインしていない場合" do
      before { put :update, params: { reaction_form: attributes, event_url_path: event.url_path } }
      let(:attributes) { { answer: { "#{event_date.id}": '3' } } }

      it { is_expected.to redirect_to root_path }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { event_url_path: url_path } }
    before { reaction }

    context "ログイン済みの場合" do
      before { log_in(user) }

      context "正しい値の場合" do
        let(:url_path) { event.url_path }

        it { expect{ subject }.to change{ Reaction.count }.by(-1) }
        it { is_expected.to redirect_to event_url(url_path) }
      end

      context "不正な値の場合" do
        let(:url_path) { '' }

        it { is_expected.to redirect_to root_path }
      end
    end

    context "ログインしていない場合" do
      let(:url_path) { event.url_path }

      it { is_expected.to redirect_to root_path }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { event_url_path: url_path } }
    before do
      log_in(user)
      reaction
    end

    context "正しい値の場合" do
      let(:url_path) { event.url_path }

      it { expect{subject}.to change{ Reaction.count }.by(-1) }
      it { is_expected.to redirect_to event_url(url_path) }
    end

    context "不正な値の場合" do
      let(:url_path) { '' }

      it { is_expected.to redirect_to root_path }
    end
  end
end
