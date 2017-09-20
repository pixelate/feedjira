# rubocop:disable Style/Documentation
# rubocop:disable Style/DocumentationMethod
module Feedjira
  module DateTimeUtilities
    class DateTimePatternParser
      # rubocop:disable Style/AsciiComments
      # Japanese Symbols are required for strange Date Strings like
      # '水, 31 8 2016 07:37:00 PDT'
      JAPANESE_SYMBOLS = %w(日 月 火 水 木 金 土).freeze
      PATTERNS = ["%m/%d/%Y %T %p", "%d %m %Y %T %Z"].freeze
      
      REGEX = Regexp.new("^(#{JAPANESE_SYMBOLS.join('|')}),\s")

      # rubocop:disable Metrics/MethodLength
      def self.parse(string)
        PATTERNS.each do |p|
          begin
            return DateTime.strptime(prepare(string), p)
          rescue StandardError => e
            Feedjira.logger.debug("Failed to parse date #{string}")
            Feedjira.logger.debug(e)
            nil
          end
        end
        raise "No pattern matched #{string}"
      end

      def self.prepare(string)
        string.gsub(REGEX, "".freeze)
      end
      private_class_method :prepare
    end
  end
end
