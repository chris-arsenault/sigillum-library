# frozen_string_literal: true

module Partitura
  module PercussionDevices
    PITCH_PATTERN = /\A[A-Ga-g](?:#+|b+)?-?\d+\z/

    # `sound` is the MusicXML standard instrument-sound id. Notation programs choose
    # the imported instrument from it; without it Dorico falls back to a generic kit
    # piece (usually a tom). The ids match what Dorico exports.
    #
    # Optional keys copy Dorico's own export where it differs from ours:
    # `musicxml_midi: false` writes no <midi-instrument> (a channel-10 kick key made
    # Dorico import the concert bass drum as a drum set), and `staff_lines` sets the
    # staff when the device has its part to itself. The MIDI file still uses `midi_note`.
    DEVICES = {
      field_drum: {
        name: "Field Drum",
        abbreviation: "Fld. Dr.",
        midi_note: 38,
        display_step: "C",
        display_octave: 5,
        sound: "drum.snare-drum"
      }.freeze,
      concert_bass_drum: {
        name: "Bass Drum",
        abbreviation: "B. Dr.",
        midi_note: 36,
        display_step: "E",
        display_octave: 4,
        sound: "drum.bass-drum",
        musicxml_midi: false,
        staff_lines: 1
      }.freeze,
      electric_snare: {
        name: "Electric Snare",
        abbreviation: "Sn.",
        midi_note: 40,
        display_step: "C",
        display_octave: 5,
        sound: "drum.snare-drum"
      }.freeze,
      closed_hi_hat: {
        name: "Closed Hi-Hat",
        abbreviation: "H.H.",
        midi_note: 42,
        display_step: "G",
        display_octave: 5,
        sound: "metal.hi-hat"
      }.freeze,
      low_tom: {
        name: "Low Tom",
        abbreviation: "L. Tom",
        midi_note: 45,
        display_step: "A",
        display_octave: 4,
        sound: "drum.tom-tom"
      }.freeze,
      high_tom: {
        name: "High Tom",
        abbreviation: "H. Tom",
        midi_note: 50,
        display_step: "E",
        display_octave: 5,
        sound: "drum.tom-tom"
      }.freeze,
      ride: {
        name: "Ride Cymbal",
        abbreviation: "Ride",
        midi_note: 51,
        display_step: "F",
        display_octave: 5,
        sound: "metal.cymbal.ride"
      }.freeze,
      suspended_cymbal: {
        name: "Suspended Cymbal",
        abbreviation: "Sus. Cym.",
        midi_note: 49,
        display_step: "A",
        display_octave: 5,
        sound: "metal.cymbal.suspended"
      }.freeze
    }.freeze

    module_function

    def normalize_map(value)
      return {}.freeze if value.nil?

      unless value.respond_to?(:each_pair)
        raise ArgumentError, "percussion_map must be a pitch-to-device hash"
      end

      value.each_pair.with_object({}) do |(source_pitch, device), normalized|
        pitch = source_pitch.to_s
        unless pitch.match?(PITCH_PATTERN)
          raise ArgumentError, "invalid percussion source pitch #{source_pitch.inspect}"
        end

        device_id = normalize_device_id(device)
        normalized[pitch] = device_id
      end.freeze
    end

    def export_map(mapping)
      mapping.map do |source_pitch, device_id|
        device = DEVICES.fetch(device_id)
        {
          source_pitch: source_pitch,
          device: device_id.to_s,
          name: device.fetch(:name),
          abbreviation: device.fetch(:abbreviation),
          midi_note: device.fetch(:midi_note),
          display_step: device.fetch(:display_step),
          display_octave: device.fetch(:display_octave),
          sound: device.fetch(:sound),
          musicxml_midi: device.fetch(:musicxml_midi, true),
          staff_lines: device[:staff_lines]
        }
      end
    end

    def normalize_device_id(value)
      device_id = value.to_sym
      return device_id if DEVICES.key?(device_id)

      raise ArgumentError, "unknown percussion device #{value.inspect}"
    rescue NoMethodError
      raise ArgumentError, "percussion device must be one of: #{DEVICES.keys.join(', ')}"
    end
    private_class_method :normalize_device_id
  end
end
