require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  let(:event_date) { create(:event_date) }
  let(:reaction) { create(:reaction, event_date: event_date, status: 1) }
  let(:second_reaction) { create(:reaction, event_date: event_date, status: 2) }

  describe "#convert_to_mark" do
    subject { convert_to_mark(event_date) }
    before do
      reaction
      second_reaction
    end

    it { is_expected.to eq ['◯', '△'] }
  end
end
