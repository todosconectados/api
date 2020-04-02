describe PreventiveReviewJob, type: :job do
  describe '#perform' do
    let!(:scheduled_for) { Time.current.advance(days: 1) }
    let!(:dialer) do
      create :dialer, :active,
      assigned_at: Time.current.advance(days: -6)
    end

    let!(:dialer_w_conferences) do
      create :dialer, :active
    end

    let!(:conference) do
      create :conference,
      dialer_id: dialer_w_conferences.id,
      started_at: Time.current.advance(days: -6)
    end

    it 'should send notification for inactivity to user without conferences' do
      VCR.use_cassette('user_send_email_for_inactivity',
        match_requests_on: [:ses_api]) do
        PreventiveReviewJob.perform_later
      end
      # Data expectations
      user = User.first!
      user_w_conferences = User.second!
      expect(user.notifications_sent).to eq(
        User::NotificationType::NO_USAGE_WARNING
      )
      expect(user_w_conferences.notifications_sent).to eq(
        User::NotificationType::NO_USAGE_WARNING
      )
    end
  end
end
