require 'rails_helper'

RSpec.describe EventDate, type: :model do
  describe "バリデーション" do
    context "正しい値の時" do
      let(:event_date) { build(:event_date) }
      it { expect(event_date).to be_valid }
    end

    context "不正な値の時" do
      context "日付が空の時" do
        let(:empty_event_date) { build(:event_date, event_date: '') }
        it { expect(empty_event_date).to be_invalid }
      end

      context "同じイベントに同じ日付が作成された時" do
        let(:event_date) { create(:event_date) }
        let(:dup_event_date) { event_date.dup }
        it { expect(dup_event_date).to be_invalid }
      end

      context "日付が不正なフォーマットの時" do
        let(:wrong_format_event_date) { build(:event_date, event_date: '2018-08') }
        it { expect(wrong_format_event_date).to be_invalid }
      end
    end
  end
end
