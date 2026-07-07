# frozen_string_literal: true

module MidiProfileHelper
  def midi_profile(bytes)
    raise "invalid MIDI header" unless bytes.byteslice(0, 4) == "MThd"

    profile = {
      format: bytes.byteslice(8, 2).unpack1("n"),
      tracks: bytes.byteslice(10, 2).unpack1("n"),
      division: bytes.byteslice(12, 2).unpack1("n"),
      note_on: 0,
      note_off: 0,
      names: 0
    }
    position = 14
    profile.fetch(:tracks).times { position = read_midi_track(bytes, position, profile) }
    profile
  end

  def read_midi_track(bytes, position, profile)
    raise "invalid MIDI track" unless bytes.byteslice(position, 4) == "MTrk"

    length = bytes.byteslice(position + 4, 4).unpack1("N")
    scan_midi_track(bytes, position + 8, position + 8 + length, profile)
  end

  def scan_midi_track(bytes, position, track_end, profile)
    running_status = nil
    while position < track_end
      _delta, position = read_variable_length(bytes, position)
      position, running_status = read_midi_event(bytes, position, profile, running_status)
    end
    position
  end

  def read_midi_event(bytes, position, profile, running_status)
    status = bytes.getbyte(position)
    return consume_meta_event(bytes, position, profile) if status == 0xFF
    return consume_sysex_event(bytes, position) if [0xF0, 0xF7].include?(status)

    consume_channel_event(bytes, position, profile, running_status, status)
  end

  def consume_meta_event(bytes, position, profile)
    position += 1
    type = bytes.getbyte(position)
    position += 1
    data_length, position = read_variable_length(bytes, position)
    profile[:names] += 1 if type == 0x03
    [position + data_length, nil]
  end

  def consume_sysex_event(bytes, position)
    data_length, position = read_variable_length(bytes, position + 1)
    [position + data_length, nil]
  end

  def consume_channel_event(bytes, position, profile, running_status, status)
    status, position, running_status = normalize_channel_status(status, position, running_status)
    event_type = status & 0xF0
    data_length = [0xC0, 0xD0].include?(event_type) ? 1 : 2
    data = bytes.byteslice(position, data_length).bytes
    count_note_event(profile, event_type, data)
    [position + data_length, running_status]
  end

  def normalize_channel_status(status, position, running_status)
    return [status, position + 1, status] if status >= 0x80

    [running_status, position, running_status]
  end

  def count_note_event(profile, event_type, data)
    velocity = data.fetch(1, 0)
    profile[:note_on] += 1 if event_type == 0x90 && velocity.positive?
    profile[:note_off] += 1 if event_type == 0x80 || (event_type == 0x90 && velocity.zero?)
  end

  def read_variable_length(bytes, position)
    value = 0
    loop do
      byte = bytes.getbyte(position)
      position += 1
      value = (value << 7) | (byte & 0x7F)
      break if (byte & 0x80).zero?
    end
    [value, position]
  end
end
