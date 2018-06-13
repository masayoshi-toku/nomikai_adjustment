require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "バリデーション" do
    context "正しい値の時" do
      let(:event) { build(:event) }
      it { expect(event).to be_valid }
    end

    context "不正な値の時" do
      context "タイトルが空の時" do
        let(:empty_name_event) { build(:event, title: '') }
        it { expect(empty_name_event).to be_invalid }
      end

      context "タイトルが100文字以上の時" do
        let(:empty_name_event) { build(:event, title: 'Example title' * 8) }
        it { expect(empty_name_event).to be_invalid }
      end

      context "同じユーザーが同じタイトルのイベントを作った時" do
        let(:event) { create(:event) }
        let(:dup_event) { event.dup }
        it { expect(dup_event).to be_invalid }
      end
    end
  end
end
