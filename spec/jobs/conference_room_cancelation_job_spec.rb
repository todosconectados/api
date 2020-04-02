describe ConferenceRoomCancelationJob, type: :job do
  describe '#perform' do
    let!(:scheduled_for) { Time.current.advance(days: 1) }

    let!(:user) do
      create :user,
      status: :active,
      notifications_sent: User::NotificationType::NO_USAGE_WARNING
    end

    let!(:user_w_conferences) do
      create :user,
      status: :active,
      notifications_sent: User::NotificationType::NO_USAGE_WARNING
    end

    let!(:dialer) do
      create :dialer, :active,
      user: user,
      assigned_at: Time.current.advance(days: -8)
    end

    let!(:dialer_w_conferences) do
      create :dialer, :active,
      user: user_w_conferences
    end

    let!(:conference) do
      create :conference,
      dialer_id: dialer_w_conferences.id,
      started_at: Time.current.advance(days: -8)
    end

    it 'should send notification for inactivity to user without conferences' do
      VCR.use_cassette('user_send_email_for_termination',
        match_requests_on: [:ses_api]) do
        ConferenceRoomCancelationJob.perform_now
      end
      # Data user expectations
      user = User.first!
      user_w_conferences = User.second!
      expect(user.dialer).to be_nil
      expect(user.notifications_sent).to eq(
        User::NotificationType::NO_USAGE_TERMINATION
      )
      expect(user_w_conferences.dialer).to be_nil
      expect(user_w_conferences.notifications_sent).to eq(
        User::NotificationType::NO_USAGE_TERMINATION
      )

      # Data dialer expectations
      dialer.reload
      dialer_w_conferences.reload
      expect(dialer.status).to eq('reserved')
      expect(dialer.user_id).to be_nil
      expect(dialer_w_conferences.status).to eq('reserved')
      expect(dialer_w_conferences.user_id).to be_nil
    end
  end
end
