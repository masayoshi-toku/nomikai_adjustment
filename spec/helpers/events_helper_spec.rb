require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:event_date) { create(:event_date, event: event) }
  let(:reaction) { create(:reaction, event_date: event_date, user: user) }

  let(:second_user) { create(:user) }
  let(:second_reaction) { create(:reaction, event_date: event_date, user: second_user, status: 2) }

  describe "#answerers" do
    subject { answerers(event) }
    before do
      reaction
      second_reaction
    end

    it { is_expected.to eq [reaction.user.name, second_reaction.user.name] }
  end

  describe "#reactions" do
    subject { reactions(event) }
    let(:second_event_date) { create(:event_date, event: event) }
    let(:third_reaction) { create(:reaction, event_date: second_event_date, user: second_user, status: 3) }
    let(:fourth_reaction) { create(:reaction, event_date: second_event_date, user: user, status: 1) }

    before do
      reaction
      second_reaction
      third_reaction
      fourth_reaction
    end

    it { is_expected.to eq [
      { event_date: event_date.event_date, marks: ['◯', '△'], counts: [1, 1, 0] },
      { event_date: second_event_date.event_date, marks: ['×', '◯'], counts: [1, 0, 1] }
       ] }
  end
end
