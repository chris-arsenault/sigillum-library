production_piece "Technique Card OV5_DOUBLE_WITHIN - OV5_DOUBLE_WITHIN" do
  meter "4/4"
  key "C"

  tempo do
    mark "quarter = 132", at: "bar 1 beat 1"
  end

# category: orch.chord_voicing
# card: OV5_DOUBLE_WITHIN
# cite: orchestration_techniques:chord_voicing
# behavior: tutti cadence G7->C that counts its doublings: a balanced C reinforces the root
#   (heaviest, across octaves) + 5th (freely doubled, neutral) with a SINGLE clean 3rd and the
#   top doubled for sheen, contrasted against a poorly-balanced C (tripled 3rd, thinned root)
#   that turns coarse, then restated balanced as the fix

  roster do
    part :flute, "Flute", music21: "Flute", family: :woodwind, description: "Flute"
    part :oboe, "Oboe", music21: "Oboe", family: :woodwind, description: "Oboe"
    part :clarinet, "Clarinet", music21: "Clarinet", family: :woodwind, description: "Clarinet"
    part :bassoon, "Bassoon", music21: "Bassoon", family: :woodwind, description: "Bassoon"
    part :trumpet, "Trumpet", music21: "Trumpet", family: :brass, description: "Trumpet"
    part :horn, "Horn", music21: "Horn", family: :brass, description: "Horn"
    part :trombone, "Trombone", music21: "Trombone", family: :brass, description: "Trombone"
    part :tuba, "Tuba", music21: "Tuba", family: :brass, description: "Tuba"
    part :violin_i, "Violin I", music21: "Violin", family: :string, description: "Violin"
    part :violin_ii, "Violin II", music21: "Violin", family: :string, description: "Violin"
    part :viola, "Viola", music21: "Viola", family: :string, description: "Viola"
    part :violoncello, "Violoncello", music21: "Violoncello", family: :string, description: "Violoncello"
    part :contrabass, "Contrabass", music21: "Contrabass", family: :string, description: "Contrabass"
  end

  section :card, "OV5_DOUBLE_WITHIN", bars: 1..4, type: :technique_card do
    journey "auditionable technique specimen for composing new material"
    destination "card behavior is audible without requiring later score reuse"

    span bars: 1..4, texture: :library_card do
      process "tutti cadence G7->C that counts its doublings: a balanced C reinforces the root (heaviest, across octaves) + 5th (freely doubled, neutral) with a SINGLE clean 3rd and the top doubled for sheen, contrasted against a poorly-balanced C (tripled 3rd, thinned root) that turns coarse, then restated balanced as the fix"

      phrase :flute_line, pitch: :degrees do
        key_context "C5"
        degrees "2{f} | 5{f} | 3'{f} | 5{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :flute_line, part: :flute, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :oboe_line, pitch: :degrees do
        key_context "C5"
        degrees "4{f} | 3{f} | 3{f} | 3{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :oboe_line, part: :oboe, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :clarinet_line, pitch: :degrees do
        key_context "C3"
        degrees "[7,2']{f} | [5,5']{f} | [3',3'']{f} | [5,5']{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :clarinet_line, part: :clarinet, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :bassoon_line, pitch: :degrees do
        key_context "C3"
        degrees "5{f} | 1{f} | 3{f} | 1{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :bassoon_line, part: :bassoon, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :trumpet_line, pitch: :degrees do
        key_context "C5"
        degrees "4{f} | 5{f} | 3{f} | 5{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :trumpet_line, part: :trumpet, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :horn_line, pitch: :degrees do
        key_context "C3"
        degrees "[7,2]{f} | [1',5]{f} | [3',3]{f} | [1',5]{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :horn_line, part: :horn, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :trombone_line, pitch: :degrees do
        key_context "C2"
        degrees "5{f} | 5{f} | 3'{f} | 5{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :trombone_line, part: :trombone, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :tuba_line, pitch: :degrees do
        key_context "C1"
        degrees "5{f} | 1'{f} | 1'{f} | 1{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :tuba_line, part: :tuba, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_i_line, pitch: :degrees do
        key_context "C5"
        degrees "2{f} | 5{f} | 3{f} | 5{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_i_line, part: :violin_i, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violin_ii_line, pitch: :degrees do
        key_context "C4"
        degrees "7{f} | 1'{f} | 3'{f} | 1'{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violin_ii_line, part: :violin_ii, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :viola_line, pitch: :degrees do
        key_context "C4"
        degrees "2{f} | 5,{f} | 3{f} | 5,{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :viola_line, part: :viola, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :violoncello_line, pitch: :degrees do
        key_context "C2"
        degrees "5{f} | 1'{f} | 3'{f} | 1'{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :violoncello_line, part: :violoncello, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

      phrase :contrabass_line, pitch: :degrees do
        key_context "C1"
        degrees "5{f} | 1'{f} | 1'{f} | 1{f}"
        rhythm  "4 | 4 | 4 | 4"
      end

      placement :contrabass_line, part: :contrabass, at: "bar 1 beat 1", role: :specimen, realization: "degrees audition specimen"

    end
  end
end
