#!/usr/bin/env ruby
# frozen_string_literal: true

require "prism"

FILES = Dir.glob("{partitura,tools,experiments,technique_library}/**/*.rb").freeze

MAX_FILE_LINES = 500
MAX_TEST_FILE_LINES = 260
MAX_METHOD_LINES = 30
MAX_STRUCTURAL_COMPLEXITY = 8
MAX_NESTING = 3

ALLOWED_DYNAMIC_DISPATCH = {
  "partitura/lib/partitura.rb" => ["instance_eval"],
  "partitura/lib/partitura/framework/registry.rb" => ["instance_eval"],
  "partitura/lib/partitura/builders.rb" => ["instance_eval"],
  "partitura/lib/partitura/production.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/controls.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/gestures.rb" => ["instance_eval", "method_missing"],
  "partitura/lib/partitura/production/builders/phrases.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/piece.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/sections.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/tempo_meter.rb" => ["instance_eval"],
  "partitura/lib/partitura/production/builders/textures.rb" => ["instance_eval"],
  "partitura/lib/partitura/surface_lab.rb" => ["instance_eval", "method_missing"]
}.freeze

BRANCH_NODES = %i[
  IfNode UnlessNode CaseNode CaseMatchNode WhenNode InNode RescueNode
  AndNode OrNode WhileNode UntilNode ForNode
].freeze

DYNAMIC_CALLS = %w[
  eval class_eval module_eval instance_eval send public_send
  method_missing define_method const_get const_set
].freeze

def inspect_node(node, file, failures, nesting: 0)
  return unless node.is_a?(Prism::Node)

  check_method(node, file, failures)
  check_dynamic_call(node, file, failures)
  current_nesting = nesting + (branch_node?(node) ? 1 : 0)
  if current_nesting > MAX_NESTING
    failures << "#{file}:#{node.location.start_line}: nesting #{current_nesting}; max #{MAX_NESTING}"
  end

  node.compact_child_nodes.each do |child|
    inspect_node(child, file, failures, nesting: current_nesting)
  end
end

def check_method(node, file, failures)
  return unless node.is_a?(Prism::DefNode)

  lines = node.location.end_line - node.location.start_line + 1
  name = node.name
  if lines > MAX_METHOD_LINES
    failures << "#{file}:#{node.location.start_line}: #{name} has #{lines} lines; max #{MAX_METHOD_LINES}"
  end

  complexity = structural_complexity(node)
  return unless complexity > MAX_STRUCTURAL_COMPLEXITY

  failures << "#{file}:#{node.location.start_line}: #{name} complexity #{complexity}; max #{MAX_STRUCTURAL_COMPLEXITY}"
end

def check_dynamic_call(node, file, failures)
  return unless node.is_a?(Prism::CallNode)

  name = node.name.to_s
  return unless DYNAMIC_CALLS.include?(name)

  allowed = ALLOWED_DYNAMIC_DISPATCH.fetch(file, [])
  return if allowed.include?(name)

  failures << "#{file}:#{node.location.start_line}: dynamic dispatch #{name.inspect} is not allowed"
end

def structural_complexity(node)
  1 + node.compact_child_nodes.sum do |child|
    next 0 unless child.is_a?(Prism::Node)

    (branch_node?(child) ? 1 : 0) + structural_complexity(child) - 1
  end
end

def branch_node?(node)
  BRANCH_NODES.include?(node.type)
end

failures = []

FILES.each do |file|
  source = File.read(file)
  result = Prism.parse(source)
  unless result.success?
    result.errors.each { |error| failures << "#{file}:#{error.location.start_line}: syntax: #{error.message}" }
    next
  end

  line_count = source.lines.length
  file_limit = file.start_with?("partitura/test/") ? MAX_TEST_FILE_LINES : MAX_FILE_LINES
  failures << "#{file}: file has #{line_count} lines; max #{file_limit}" if line_count > file_limit

  inspect_node(result.value, file, failures)
end

if failures.empty?
  puts "structural lint: ok"
else
  warn "structural lint failed:"
  failures.each { |failure| warn "  #{failure}" }
  exit 1
end
