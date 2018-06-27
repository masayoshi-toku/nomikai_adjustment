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
        let(:event_date) { create(:event_date) }
        let(:dup_event_date) { event_date.dup }
        let(:attributes) { dup_event_date.attributes }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe "#count_status" do
    subject { event_date.count_status }
    before do
      reaction
      second_reaction
    end
    let(:event_date) { create(:event_date) }
    let(:reaction) { create(:reaction, event_date: event_date, status: 1) }
    let(:second_reaction) { create(:reaction, event_date: event_date, status: 2) }

    it { is_expected.to eq [1, 1, 0]}
  end
end
