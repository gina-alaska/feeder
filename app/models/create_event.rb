class CreateEvent < Event
  def type
    "create"
  end

  def payload
    {
      data_url: self.entry.image.url(host: Rails.application.routes.default_url_options[:host]),
      event_date: self.entry.event_at.iso8601,
      event_url: self.helpers.feed_entry_url(self.entry.feed, self.entry),
      feed_url: self.helpers.feed_url(self.entry.feed)
    }
  end
end
