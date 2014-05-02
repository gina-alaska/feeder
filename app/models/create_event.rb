class CreateEvent < Event
  def payload
    {
      type: 'CREATE',
      source_url: self.entry.image.url
    }
  end
end
