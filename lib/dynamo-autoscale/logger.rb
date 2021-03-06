# dont buffer these, might be important
STDERR.sync = true

require_relative 'ext/yell/mono_logger_adapter'

# TODO: abstraction
LOGGER_ID='dynamo'
LOGGER_LEVEL_DEFAULT = :info
LOGGER_FORMAT = "%d [%5L] %p %h : %m"
LOGGER_TIME_FORMAT = "%F %T.%L"

# enforce logging level defaults if unset
$logger_level ||= LOGGER_LEVEL_DEFAULT

module DynamoAutoscale
  module Logger
    def self.logger
      # see https://github.com/rudionrails/yell .. https://github.com/rudionrails/yell/wiki/101-formatting-log-messages
      @@logger ||= Yell.new do |l|
        l.name = LOGGER_ID
        l.adapter :mono_logger_adapter, level: "gte.#{$logger_level}", format: Yell.format(LOGGER_FORMAT, LOGGER_TIME_FORMAT)
        # l.adapter :stdout, level: "gte.#{$logger_level}", format: Yell.format(LOGGER_FORMAT, LOGGER_TIME_FORMAT)
        # l.adapter :stderr, level: [:error, :fatal], format: Yell.format(LOGGER_FORMAT, LOGGER_TIME_FORMAT)
      end
      @@logger
    end

    def logger
      DynamoAutoscale::Logger.logger
    end

    def self.included base
      base.extend DynamoAutoscale::Logger
    end
  end
end
