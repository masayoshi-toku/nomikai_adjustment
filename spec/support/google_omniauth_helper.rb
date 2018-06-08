module GoogleOmniauthHelper
  OmniAuth.config.test_mode = true

  def google_mock(name:, email:, domain:)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google',
      uid: 1234567890,
      info: {
        name: name,
        email: email
      },
      credentials: {
        token: 'example0607'
      },
      extra: {
        raw_info: {
          hd: domain
        }
      }
    )
  end
end
