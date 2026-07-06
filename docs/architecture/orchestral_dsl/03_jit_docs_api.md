# JIT Documentation API

The DSL must be discoverable at composition time. Agents should ask focused questions instead of
loading the full documentation set.

## CLI

```bash
framework/orchestral_dsl/ruby/bin/dsl_help index
framework/orchestral_dsl/ruby/bin/dsl_help production
framework/orchestral_dsl/ruby/bin/dsl_help decision
framework/orchestral_dsl/ruby/bin/dsl_help degrees
framework/orchestral_dsl/ruby/bin/dsl_help staff_grid
framework/orchestral_dsl/ruby/bin/dsl_help controls
framework/orchestral_dsl/ruby/bin/dsl_help hybrid --json
framework/orchestral_dsl/ruby/bin/dsl_help transport_export
```

## Ruby API

```ruby
require "sigillum/orchestral_dsl"

puts Sigillum::OrchestralDSL.help(:decision)
data = Sigillum::OrchestralDSL.help_data(:hybrid)
```

## Response Contract

Every help response includes:

- `topic`: the topic answered.
- `use_when`: when to use this surface/API.
- `rules`: non-negotiable constraints.
- `example`: minimal source example.
- `next_topics`: focused follow-up topics.
- `docs`: files to load if more context is needed.

## Agent Protocol

1. Ask `dsl_help index`.
2. Ask `dsl_help production` before authoring production DSL.
3. Ask `dsl_help decision` if choosing a surface.
4. Ask exactly one surface topic before authoring that surface.
5. Use `production_view` readout/projection commands after authoring.
6. Only load the long docs if the JIT response is insufficient.

## Production Readout API

```bash
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb phrases
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb harmony_with_melody --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb verticals --bars 1-4
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb line --part clarinet
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb controls
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb transport
framework/orchestral_dsl/ruby/bin/production_view SOURCE.rb compile
```

Ruby:

```ruby
piece = Sigillum::OrchestralDSL.load_production_file("SOURCE.rb")
puts Sigillum::OrchestralDSL.production_readout(piece, :foreground, bars: 1..8)
json = Sigillum::OrchestralDSL.production_transport_json(piece)
```

## Production Export API

```bash
framework/orchestral_dsl/ruby/bin/production_export SOURCE.rb outputs/orchestral_dsl --stem study
framework/orchestral_dsl/ruby/bin/production_export SOURCE.rb outputs/orchestral_dsl --stem study --transport-only
python -m framework.orchestral_dsl_transport outputs/orchestral_dsl/study.sigillum_transport.json outputs/orchestral_dsl --stem study
```
