class PingEvent < Event

  def type
    'ping'
  end

  def payload
    {
      event_at: Time.now.utc.iso8601,
      feed_id: self.web_hook.feed.slug
    }
  end
end
