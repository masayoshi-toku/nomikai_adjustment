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

    let(:event_date) { create(:event_date) }
    let(:reaction) { create(:reaction, event_date: event_date, status: status) }
    let(:second_reaction) { create(:reaction, event_date: event_date, status: second_status) }
    let(:third_reaction) { create(:reaction, event_date: event_date, status: third_status) }

    context "回答者がいる時" do
      before do
        reaction
        second_reaction
        third_reaction
      end

      context "全てが'◯'の時" do
        let(:status) { 1 }
        let(:second_status) { 1 }
        let(:third_status) { 1 }

        it { is_expected.to eq [3, 0, 0]}
      end

      context "全てが'△'の時" do
        let(:status) { 2 }
        let(:second_status) { 2 }
        let(:third_status) { 2 }

        it { is_expected.to eq [0, 3, 0]}
      end

      context "全てが'×'の時" do
        let(:status) { 3 }
        let(:second_status) { 3 }
        let(:third_status) { 3 }

        it { is_expected.to eq [0, 0, 3]}
      end

      context "全てのstatusが選択されている時" do
        let(:status) { 1 }
        let(:second_status) { 2 }
        let(:third_status) { 3 }

        it { is_expected.to eq [1, 1, 1]}
      end

      context "複数statusが重複する時" do
        let(:status) { 1 }
        let(:second_status) { 1 }
        let(:third_status) { 3 }

        it { is_expected.to eq [2, 0, 1]}
      end
    end

    context "回答者がいない時" do
      it { is_expected.to eq [0, 0, 0]}
    end
  end

  describe "scope" do
    describe "latest" do
      let(:event) { create(:event) }
      let(:event_date) { create(:event_date, event: event) }
      let(:second_event_date) { create(:event_date, event: event) }

      before do
        event_date
        second_event_date
      end

      it { expect(event.event_dates.latest).to eq [event_date, second_event_date] }
    end
  end
end
