# ping-event-spec

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

## 1. Purpose

This specification documentents the payload used by the ping event hook

## 2. File format

ping-event is a set of agreed-upon 'data fields' in the JSON format as described in RFC 4627.

Implementations MUST treat unknown keys as if they weren't present. However, implementations MUST expose unknown key/values in their API so that API users can optionally handle these keys. Implementations MUST treat invalid values for keys as if they weren't present. If the key is required, implementations MUST treat the entire create-event payload file as invalid and refuse operation.

```javascript
// ping-event json payload
{
  // REQUIRED. A semver.org style version number.  Describes the version of the create-event spec that is implemented by this JSON object
  "version": "0.0.1",
  
  // REQUIRED: The date/time the event data was generated. The date/time format MUST conform to ISO8601 
  "event_date": "2014-05-02T10:51:35-08:00"
}
```