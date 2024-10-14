# frozen_string_literal: true

module Operation
  module Run
    def run
      run_steps
    rescue StandardError => e
      handle_exception(e)
    end

    def run_steps
      raise 'run_steps must be defined to use Operation::Run'
    end

    def handle_exception(exception)
      return handle_operation_result_failure(exception) if exception.is_a?(OperationResultFailureException)

      handle_unexpected_failure(exception)
    end

    def handle_operation_result_failure(exception)
      Reporter.warning(exception)
      Operation::Result.new(success: false, errors: exception.result.errors, object: nil)
    end

    def handle_unexpected_failure(exception)
      Reporter.error(exception)
      raise exception if Rails.env.test?

      Operation::Result.new(success: false, errors: [exception], object: nil)
    end
  end
end
