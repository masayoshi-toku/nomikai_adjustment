require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe "バリデーション" do
    context "正しい値の時" do
      subject { build(:reaction) }
      it { is_expected.to be_valid }
    end

    context "不正な値の時" do
      context "ステータスに不正な値がある時" do
        subject { build(:reaction, status: attribute) }

        context "存在しない時" do
          let(:attribute) { nil }
          it { is_expected.to be_invalid }
        end

        context "空である時" do
          let(:attribute) { '' }
          it { is_expected.to be_invalid }
        end

        context "値が1~3以外である時" do
          context "値が0の時" do
            let(:attribute) { 0 }
            it { is_expected.to be_invalid }
          end

          context "値が4の時" do
            let(:attribute) { 4 }
            it { is_expected.to be_invalid }
          end
        end
      end

      context "ユーザーに不正な値がある時" do
        subject { build(:reaction, user_id: attribute) }

        context "存在しない時" do
          let(:attribute) { nil }
          it { is_expected.to be_invalid }
        end

        context "空である時" do
          let(:attribute) { '' }
          it { is_expected.to be_invalid }
        end
      end

      context "イベント候補日に不正な値がある時" do
        subject { build(:reaction, event_date_id: attribute) }

        context "存在しない時" do
          let(:attribute) { nil }
          it { is_expected.to be_invalid }
        end

        context "空である時" do
          let(:attribute) { '' }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe "scope" do
      describe "latest" do
        let(:event_date) { create(:event_date) }
        let(:reaction) { create(:reaction, event_date: event_date) }
        let(:second_reaction) { create(:reaction, event_date: event_date) }

        before do
          reaction
          second_reaction
        end

        it { expect(event_date.reactions.latest).to eq [reaction, second_reaction] }
      end
    end
  end
end
