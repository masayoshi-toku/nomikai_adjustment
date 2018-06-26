require 'rails_helper'

RSpec.describe ReactionForm, type: :model do
  describe "#create" do
    before { event_date }
    let(:form) { ReactionForm.new(attributes.merge({ user: user })) }
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:event_date) { create(:event_date, event: event) }
    let(:second_event_date) { create(:event_date, event: event) }
    let(:attributes) { { event_url_path: event.url_path, answer: answer } }
    let(:answer) do
      answer = {}
      answer["#{event_date.id}"] = '2'
      answer["#{second_event_date.id}"] = '3'
      answer
    end

    context "正しい値の場合" do
      it { expect(form.create).to be_truthy }
      it { expect { form.create }.to change { Reaction.count }.by(2) }
    end

    context "不正な値の場合" do
      context "answerが空の場合" do
        let(:answer) do
          answer = {}
          answer["#{event_date.id}"] = ''
        end

        it { expect(form.create).to be_falsey }
      end

      context "ユーザーが不明の場合" do
        before { form.user = nil }

        it { expect(form.create).to be_falsey }
      end

      context "eventのURLが空の場合" do
        before { form.event_url_path = '' }

        it { expect(form.create).to be_falsey }
      end
    end
  end
end
