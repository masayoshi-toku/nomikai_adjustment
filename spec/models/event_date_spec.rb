require 'rails_helper'

RSpec.describe EventDate, type: :model do
  describe "バリデーション" do
    subject { build :event_date, attributes }

    context "正しい値の時" do
      let(:attributes) { attributes_for(:event_date) }
      it { is_expected.to be_valid }
    end

    context "不正な値の時" do
      context "イベントと紐づいていない時" do
        let(:attributes) { { event: nil } }
        it { is_expected.to be_invalid }
      end

      context "event_idが空の時" do
        let(:attributes) { { event_id: '' } }
        it { is_expected.to be_invalid }
      end

      context "日付が空の時" do
        let(:attributes) { { event_date: '' } }
        it { is_expected.to be_invalid }
      end

      context "同じイベントに同じ日付が作成された時" do
        before { create(:event_date) }
        let(:attributes) { attributes_for(:event_date) }
        it { expect{ subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end
end
