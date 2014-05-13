class CreateEvent < Event
  def type
    "create"
  end

  def payload
    {
      data_url: File.join(self.helpers.root_url, self.entry.image.remote_url,
      event_date: self.entry.event_at.iso8601,
      event_url: self.helpers.slug_entry_url(self.entry.feed, self.entry),
      feed_url: self.helpers.slug_url(self.entry.feed)
    }
  end
end
