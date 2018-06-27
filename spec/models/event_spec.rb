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
        let(:long_title_event) { build(:event, title: 'これは１５文字のタイトルです。' * 7) }
        it { expect(long_title_event).to be_invalid }
      end

      context "同じユーザーが同じタイトルのイベントを作った時" do
        let(:event) { create(:event) }
        let(:dup_event) { event.dup }
        it { expect(dup_event).to be_invalid }
      end

      context "イベント用のURLが無い時" do
        let(:empty_url_event) { build(:event, url_path: '') }
        it { expect(empty_url_event).to be_invalid }
      end

      context "イベントURLが重複した時" do
        let(:event) { create(:event) }
        let(:dup_url) { event.url_path }
        let(:other_user) { create(:user, name: 'Mr.other_example', email: 'other_example@mwed.co.jp') }
        let(:same_url_event) { build(:event, user_id: other_user.id, title: '第1回飲み会（仮）', url_path: dup_url) }

        it { expect(same_url_event).to be_invalid }
      end
    end
  end

  describe "#answerers" do
    subject { event.answerers }
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:event) { create(:event) }
    let(:event_date) { create(:event_date, event: event) }
    let(:reaction) { create(:reaction, event_date: event_date, user: user) }
    let(:second_reaction) { create(:reaction, event_date: event_date, user: second_user) }
    before do
      reaction
      second_reaction
    end

    it { is_expected.to eq [user.name, second_user.name] }
  end
end
