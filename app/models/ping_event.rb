class PingEvent < Event

  def payload
    {
      type: 'PING',
      feed_id: self.web_hook.feed.slug
    }
  end
end
