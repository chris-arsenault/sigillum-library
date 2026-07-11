# frozen_string_literal: true

module Partitura
  module PercussionDevices
    PITCH_PATTERN = /\A[A-Ga-g](?:#+|b+)?-?\d+\z/

    DEVICES = {
      field_drum: {
        name: "Field Drum",
        abbreviation: "Fld. Dr.",
        midi_note: 38,
        display_step: "C",
        display_octave: 5
      }.freeze,
      concert_bass_drum: {
        name: "Concert Bass Drum",
        abbreviation: "B. Dr.",
        midi_note: 36,
        display_step: "F",
        display_octave: 4
      }.freeze,
      suspended_cymbal: {
        name: "Suspended Cymbal",
        abbreviation: "Sus. Cym.",
        midi_note: 49,
        display_step: "A",
        display_octave: 5
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
          display_octave: device.fetch(:display_octave)
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
