module Fastlane
  module Actions
    class GenerateAcknowledgementsAction < Action
      def self.run(params)
        sh "bin/generate-acknowledgements"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Generates acknowledgements in Settings.bundle"
      end

      def self.authors
        ["sharplet"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
