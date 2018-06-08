require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:user) { User.new }

    context '名前が空の時' do
      it '作成できない' do
        user.email = 'hoge@example.com'
        user.name = ''
        expect(user.save).to be false
      end
    end

    context 'メールアドレスが空の時' do
      it '作成できない' do
        user.email = ''
        user.name = 'hoge'
        expect(user.save).to be false
      end
    end
  end
end
