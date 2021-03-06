# create-event-spec

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

## 1. Purpose

This specification documents the payload used by the create event hook

## 2. File format

create-event is a set of agreed-upon 'data fields' in the JSON format as described in RFC 4627.

Implementations MUST treat unknown keys as if they weren't present. However, implementations MUST expose unknown key/values in their API so that API users can optionally handle these keys. Implementations MUST treat invalid values for keys as if they weren't present. If the key is required, implementations MUST treat the entire create-event payload file as invalid and refuse operation.

```javascript
// create-event json payload
{
  // REQUIRED: A url to the data source that triggered this event.  MUST be a valid URL
  "data_url": "http://valid_url.com/to/something.tif"

  // REQUIRED: The date/time the event data was generated. The date/time format MUST conform to ISO8601
  "event_date": "2014-05-02T10:51:35-08:00"

  // OPTIONAL: A url to a page that describes or provides more information about the event
  "event_url": "http://valid_url.com/to_event"

  // OPTIONAL: A url to the page for the feed that this event belongs to
  "feed_url": "http://valid_url.com/to_feed"
}
```
