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
          [4..10].each do |status|
            let(:attribute) { status }
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
  end
end
