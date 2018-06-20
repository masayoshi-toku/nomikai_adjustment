require 'rails_helper'

RSpec.describe EventForm, type: :model do
  describe "#create" do
    let(:form) { EventForm.new(attributes.merge({ current_user: user, event: Event.new })) }
    let(:user) { create(:user) }

    context "正しい値の場合" do
      let(:attributes) { { title: "第一回飲み会", event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

      it { expect(form.create).to be_truthy }
      it { expect { form.create }.to change { Event.count }.by(1) }
      it { expect { form.create }.to change { EventDate.count }.by(3) }
    end

    context "不正な値の場合" do
      context "タイトルが空の場合" do
        let(:attributes) { { title: "", event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { expect(form.create).to be_falsey }
      end

      context "ユーザーが不明の場合" do
        before { form.current_user = nil }
        let(:attributes) { { title: "第一回飲み会", event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { expect(form.create).to be_falsey }
      end

      context "タイトルの文字数が100文字以上の場合" do
        let(:attributes) { { title: "これは１５文字のタイトルです。" * 7, event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { expect(form.create).to be_falsey }
      end

      context "日付が入力されていない場合" do
        let(:attributes) { { title: "第一回飲み会", event_dates_text: "" } }

        it { expect(form.create).to be_falsey }
      end
    end
  end
end
