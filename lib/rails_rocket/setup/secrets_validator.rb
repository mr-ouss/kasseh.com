# frozen_string_literal: true

module RailsRocket
  module Setup
    class SecretsValidator
      attr_reader :vault_name, :config

      def initialize(vault_name, config = {})
        @vault_name = vault_name
        @config = config
      end

      def validate
        {
          vault_accessible: vault_accessible?,
          secrets: check_all_secrets,
          summary: generate_summary
        }
      end

      private

      def vault_accessible?
        # Check if 1Password CLI is installed and vault is accessible
        return false unless op_cli_installed?

        # Try to list items in the vault
        result = `op item list --vault="#{vault_name}" 2>&1`
        $?.success?
      rescue => e
        false
      end

      def op_cli_installed?
        result = `which op 2>&1`
        $?.success?
      end

      def check_all_secrets
        secrets = []

        # Always required secrets
        secrets << check_secret("rails-master-key", "password", "Rails Master Key", required: true)
        secrets << check_secret("deploy-ssh-key", "private key", "Deployment SSH Key", required: true)
        secrets << check_secret("smtp-credentials", "username", "SMTP Credentials", required: true, fields: %w[username password server from_email])

        # OAuth secrets (conditionally required)
        if config["github_oauth"] == "1" || config[:github_oauth] == "1"
          secrets << check_secret("github-oauth-app", "client_id", "GitHub OAuth", required: false, fields: %w[client_id credential])
        end

        if config["google_oauth"] == "1" || config[:google_oauth] == "1"
          secrets << check_secret("google-oauth-app", "client_id", "Google OAuth", required: false, fields: %w[client_id credential])
        end

        if config["apple_oauth"] == "1" || config[:apple_oauth] == "1"
          secrets << check_secret("apple-oauth-app", "client_id", "Apple OAuth", required: false, fields: %w[client_id team_id key_id private_key])
        end

        secrets
      end

      def check_secret(item_name, primary_field, display_name, required: true, fields: nil)
        result = {
          name: display_name,
          item_name: item_name,
          required: required,
          exists: false,
          accessible: false,
          missing_fields: [],
          error: nil
        }

        unless op_cli_installed?
          result[:error] = "1Password CLI not installed"
          return result
        end

        # Check if item exists
        check_result = `op item get "#{item_name}" --vault="#{vault_name}" 2>&1`

        if $?.success?
          result[:exists] = true
          result[:accessible] = true

          # If specific fields are required, check them
          if fields
            fields.each do |field|
              field_result = `op item get "#{item_name}" --vault="#{vault_name}" --fields "#{field}" 2>&1`
              unless $?.success? && !field_result.strip.empty?
                result[:missing_fields] << field
              end
            end
          end
        else
          # Item doesn't exist or can't be accessed
          if check_result.include?("isn't an item")
            result[:error] = "Item not found in vault"
          elsif check_result.include?("not currently signed in")
            result[:error] = "Not signed in to 1Password"
          else
            result[:error] = "Unable to access item"
          end
        end

        result
      rescue => e
        result[:error] = e.message
        result
      end

      def generate_summary
        return { status: "error", message: "1Password CLI not installed. Install from https://1password.com/downloads/command-line/" } unless op_cli_installed?
        return { status: "error", message: "Cannot access vault '#{vault_name}'. Make sure you're signed in: eval $(op signin)" } unless vault_accessible?

        all_secrets = check_all_secrets
        required_secrets = all_secrets.select { |s| s[:required] }
        missing_required = required_secrets.reject { |s| s[:accessible] && s[:missing_fields].empty? }

        if missing_required.any?
          {
            status: "warning",
            message: "#{missing_required.count} required secret(s) need attention",
            missing_count: missing_required.count,
            total_count: required_secrets.count
          }
        else
          {
            status: "success",
            message: "All required secrets are configured correctly!",
            missing_count: 0,
            total_count: required_secrets.count
          }
        end
      end
    end
  end
end
