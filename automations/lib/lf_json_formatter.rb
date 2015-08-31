require 'rspec/core/formatters/base_formatter'
require 'json'

class LFJsonFormatter < RSpec::Core::Formatters::BaseFormatter
  attr_reader :output_hash

  def initialize(output)
    super
    @output_hash = {}
    @pending_count_to_minus = 0
  end

  def message(message)
    (@output_hash[:messages] ||= []) << message
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    failure_count -= @pending_count_to_minus if @pending_count_to_minus != 0
    super(duration, example_count, failure_count, pending_count)
    @output_hash[:summary] = {
      duration: duration,
      total_steps: example_count,
      total_failed: failure_count,
      total_uncertain: pending_count
    }
    @output_hash[:summary_line] = summary_line(example_count, failure_count, pending_count)
  end

  def summary_line(total_steps, total_failed, total_uncertain)
    summary = pluralize(total_steps, 'example')
    summary << ", #{pluralize(total_failed, 'failure')}"
    summary << ", #{total_uncertain} pending" if total_uncertain > 0
    summary
  end

  def custom_example_name_status(example)
    if example.execution_result[:pending_fixed] && example.execution_result[:pending_message].start_with?('***')
      @pending_count_to_minus += 1
      name = example.execution_result[:pending_message]
      name.slice! '***'
      { status: 'passed', name: name }
    else
      name = example.description
      name += " (PENDING: #{example.execution_result[:pending_message]})" if example.execution_result[:status].downcase == 'pending'
      if name.downcase.include? 'blocked:'
        name.slice! '(PENDING: No reason given)' if example.execution_result[:pending_message] == 'No reason given'
        name.slice! 'PENDING: ' if example.execution_result[:pending_message].include? 'Precondition failed'
      end
      { status: example.execution_result[:status], name: name }
    end
  end

  def recur_steps(nest)
    its =
      if nest.examples.any?
        nest.examples.map do |example|
          status_name = custom_example_name_status example

          {
            name: status_name[:name],
            status: status_name[:status],
            duration: Time.at(example.execution_result[:run_time]).utc.strftime('%H:%M:%S.%5N')
          }.tap do |it|
            if e = example.exception
              rindex = e.backtrace.rindex { |n| n.include? example.metadata[:file_path][1..-1] } || -1

              if e.class == RSpec::Expectations::ExpectationNotMetError
                message = e.message
                backtrace = ''
              else
                message = 'Error with testing page - see debug info for details'
                backtrace = "#{e} \n" + e.backtrace[0..rindex].join("\n")
              end

              it[:exception] = {
                message: message,
                backtrace: backtrace,
                file_path: example.metadata[:location]
              }
            end
          end
        end
      end

    contexts =
      if nest.children.any?
        nest.children.map do |child|
          child_context = recur_steps(child)
          next if child_context.empty?

          {
            name: child.description,
            steps: child_context
          }
        end
      end

    ([] << its << contexts).flatten.compact
  end

  def stop
    super
    nest1 = RSpec::Core::ExampleGroup.children[0]
    name = nest1.metadata[:example_group][:description]
    step = recur_steps nest1

    @output_hash[:cases] = {
      name: name,
      total_steps: nil,
      total_passed: nil,
      total_failed: nil,
      total_uncertain: nil,
      duration: nil,
      steps: step
    }
  end

  def close
    @output_hash[:cases][:total_steps] = example_count
    @output_hash[:cases][:total_passed] = example_count - failure_count - pending_count
    @output_hash[:cases][:total_failed] = failure_count
    @output_hash[:cases][:total_uncertain] = pending_count
    @output_hash[:cases][:duration] = Time.at(duration).utc.strftime('%H:%M:%S')

    output.write @output_hash[:cases].to_json
    output.close if IO == output && output != $stdout
  end
end
