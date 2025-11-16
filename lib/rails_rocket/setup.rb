module RailsRocket
  module Setup
    SETUP_FLAG_FILE = Rails.root.join(".railsrocket-configured")

    class << self
      def configured?
        # Check if setup has been completed
        SETUP_FLAG_FILE.exist?
      end

      def mark_configured!
        # Create flag file to indicate setup is complete
        FileUtils.touch(SETUP_FLAG_FILE)
      end

      def reset!
        # Remove flag file to re-run setup (useful for development)
        FileUtils.rm_f(SETUP_FLAG_FILE)
      end

      def required?
        # Setup is required in development if not yet configured
        Rails.env.development? && !configured?
      end
    end
  end
end
