require 'rails_helper'

RSpec.describe ReactionForm, type: :model do
  describe "#create" do
    subject { form.create }
    let(:form) { ReactionForm.new(attributes.merge({ user: user })) }
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let!(:event_date) { create(:event_date, event: event) }
    let(:second_event_date) { create(:event_date, event: event) }
    let(:attributes) { { answer: answer } }
    let(:answer) do
      answer = {}
      answer["#{event_date.id}"] = '2'
      answer["#{second_event_date.id}"] = '3'
      answer
    end

    context "正しい値の場合" do
      it { is_expected.to be_truthy }
      it { expect { subject }.to change { Reaction.count }.by(2) }
    end

    context "不正な値の場合" do
      context "answerが空の場合" do
        let(:answer) do
          answer = {}
          answer["#{event_date.id}"] = ''
        end

        it { is_expected.to be_falsey }
      end

      context "ユーザーが不明の場合" do
        before { form.user = nil }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe "#update_or_create" do
    subject { form.update_or_create }
    before do
      event
      reaction
      second_reaction
    end

    let(:form) { ReactionForm.new(attributes.merge({ user: user })) }
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:event_date) { create(:event_date, event: event) }
    let(:second_event_date) { create(:event_date, event: event) }
    let(:reaction) { create(:reaction, event_date: event_date, user: user) }
    let(:second_reaction) { create(:reaction, event_date: second_event_date, user: user) }
    let(:attributes) { { answer: answer } }
    let(:answer) do
      answer = {}
      answer["#{event_date.id}"] = '2'
      answer["#{second_event_date.id}"] = '3'
      answer
    end
    let(:old_status) { reaction.status }
    let(:second_old_status) { second_reaction.status }
    let(:updated_reaction) { Reaction.find_by(id: reaction.id) }
    let(:updated_second_reaction) { Reaction.find_by(id: second_reaction.id) }

    context "正しい値の場合" do
      before do
        old_status
        second_old_status
      end

      it :aggregate_failures do
        is_expected.to be_truthy
        expect(updated_reaction.status).not_to eq old_status
        expect(updated_reaction.status).to eq 2
        expect(updated_second_reaction.status).not_to eq second_old_status
        expect(updated_second_reaction.status).to eq 3
      end

      context "回答済みの候補日と未回答の候補日が混在している時" do
        let(:third_event_date) { create(:event_date, event: event) }
        before { answer["#{third_event_date.id}"] = '1' }

        it :aggregate_failures do
          is_expected.to be_truthy
          expect(updated_reaction.status).not_to eq old_status
          expect(updated_reaction.status).to eq 2
          expect(updated_second_reaction.status).not_to eq second_old_status
          expect(updated_second_reaction.status).to eq 3
        end

        it "既存の回答は更新され、新しい回答は作成される" do
          expect{ subject }.to change { Reaction.count }.by(1)
        end
      end
    end

    context "不正な値の場合" do
      context "answerが空の場合" do
        let(:answer) do
          answer = {}
          answer["#{event_date.id}"] = ''
        end

        it { is_expected.to be_falsey }
      end

      context "ユーザーが不明の場合" do
        before { form.user = nil }

        it { is_expected.to be_falsey }
      end

      context "既存の回答の更新は成功するが、新しい回答の登録が失敗する時" do
        let(:third_event_date) { create(:event_date, event: event) }
        let(:third_reaction) { Reaction.find_by(event_date_id: third_event_date.id) }

        before do
          answer["#{third_event_date.id}"] = '10'
          old_status
          second_old_status
        end

        it :aggregate_failures do
          is_expected.to be_falsey
          expect(updated_reaction.status).to eq old_status
          expect(updated_reaction.status).not_to eq 2
          expect(updated_second_reaction.status).to eq second_old_status
          expect(updated_second_reaction.status).not_to eq 3
          expect(third_reaction).to eq nil
        end
      end

      context "新しい回答の登録は成功するが、既存の回答の更新が失敗する時" do
        let(:third_event_date) { create(:event_date, event: event) }
        let(:third_reaction) { Reaction.find_by(event_date_id: third_event_date.id) }

        before do
          answer["#{event_date.id}"] = '2'
          answer["#{second_event_date.id}"] = '10'
          answer["#{third_event_date.id}"] = '1'
          old_status
          second_old_status
        end

        it :aggregate_failures do
          is_expected.to be_falsey
          expect(updated_reaction.status).to eq old_status
          expect(updated_reaction.status).not_to eq 2
          expect(updated_second_reaction.status).to eq second_old_status
          expect(updated_second_reaction.status).not_to eq 10
          expect(third_reaction).to eq nil
        end
      end
    end
  end
end
