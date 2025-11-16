module RailsRocket
  module Setup
    class ConfigUpdater
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def update_all!
        Rails.logger.info "🚀 RailsRocket Setup: Updating configuration files..."

        update_user_model if config[:admin_email].present?
        update_vault_references if config[:vault_name].present?
        update_app_name if config[:app_name].present?
        update_landing_page if config[:app_name].present?
        update_readme if config[:app_name].present?
        save_logo if config[:logo].present?
        save_favicon if config[:favicon].present?
        update_theme_colors if config[:primary_color].present?
        update_deploy_config if deployment_config_present?

        Rails.logger.info "✅ RailsRocket Setup: Configuration complete!"
        true
      rescue => e
        Rails.logger.error "❌ RailsRocket Setup Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        false
      end

      private

      def update_user_model
        file_path = Rails.root.join("app/models/user.rb")
        content = File.read(file_path)

        updated = content.gsub(
          /PRIMARY_ADMIN_EMAIL = ".*"\.freeze/,
          %(PRIMARY_ADMIN_EMAIL = "#{config[:admin_email]}".freeze)
        )

        File.write(file_path, updated)
        Rails.logger.info "  ✓ Updated admin email in User model"
      end

      def update_vault_references
        # Update .github/workflows/.env.deploy
        update_vault_in_file(
          Rails.root.join(".github/workflows/.env.deploy"),
          "YourApp",
          config[:vault_name]
        )

        # Update .github/workflows/.env.test
        update_vault_in_file(
          Rails.root.join(".github/workflows/.env.test"),
          "YourApp",
          config[:vault_name]
        )

        # Update .kamal/secrets
        update_vault_in_file(
          Rails.root.join(".kamal/secrets"),
          "YourApp",
          config[:vault_name]
        )

        Rails.logger.info "  ✓ Updated 1Password vault name to: #{config[:vault_name]}"
      end

      def update_vault_in_file(file_path, old_vault, new_vault)
        return unless File.exist?(file_path)

        content = File.read(file_path)
        updated = content.gsub(/op:\/\/#{old_vault}\//, "op://#{new_vault}/")
        updated = updated.gsub(/"#{old_vault}"/, %("#{new_vault}"))

        File.write(file_path, updated)
      end

      def update_app_name
        # Update application.rb module name comment
        file_path = Rails.root.join("config/application.rb")
        content = File.read(file_path)

        # We can't easily change the module name without breaking things,
        # but we can add a configuration
        unless content.include?("config.application_name")
          updated = content.sub(
            /class Application < Rails::Application/,
            "class Application < Rails::Application\n    config.application_name = \"#{config[:app_name]}\""
          )
          File.write(file_path, updated)
        end

        Rails.logger.info "  ✓ Updated application name to: #{config[:app_name]}"
      end

      def update_landing_page
        file_path = Rails.root.join("app/views/landing/index.html.erb")
        content = File.read(file_path)

        # Update the logo text
        updated = content.gsub(
          /Rails<span.*?>Rocket<\/span>/,
          config[:app_name]
        )

        # Update title
        updated = updated.gsub(
          /Production-Ready Rails 8 Template/,
          config[:app_name]
        )

        # Update footer
        updated = updated.gsub(
          /© <%= Time\.current\.year %> RailsRocket\./,
          "© <%= Time.current.year %> #{config[:app_name]}."
        )

        File.write(file_path, updated)
        Rails.logger.info "  ✓ Updated landing page with app name"
      end

      def update_readme
        file_path = Rails.root.join("README.md")
        content = File.read(file_path)

        # Update title and references
        updated = content.gsub(/RailsRocket/, config[:app_name])
        updated = updated.gsub(/railsrocket/, config[:app_name].parameterize)

        File.write(file_path, updated)
        Rails.logger.info "  ✓ Updated README with app name"
      end

      def save_logo
        return unless config[:logo].respond_to?(:read)

        filename = "logo#{File.extname(config[:logo].original_filename)}"
        path = Rails.root.join("app/assets/images", filename)

        File.open(path, "wb") do |file|
          file.write(config[:logo].read)
        end

        Rails.logger.info "  ✓ Saved logo as: #{filename}"
      end

      def save_favicon
        return unless config[:favicon].respond_to?(:read)

        # Save as favicon.ico
        path = Rails.root.join("public/favicon.ico")

        File.open(path, "wb") do |file|
          file.write(config[:favicon].read)
        end

        Rails.logger.info "  ✓ Saved favicon"
      end

      def update_theme_colors
        file_path = Rails.root.join("app/assets/stylesheets/application.css")
        content = File.read(file_path)

        # Update the accent color
        updated = content.gsub(
          /--color-accent: #[0-9a-fA-F]{6};/,
          "--color-accent: #{config[:primary_color]};"
        )

        File.write(file_path, updated)
        Rails.logger.info "  ✓ Updated theme color to: #{config[:primary_color]}"
      end

      def deployment_config_present?
        config[:server_hostname].present? ||
          config[:domain_name].present? ||
          config[:registry_url].present?
      end

      def update_deploy_config
        file_path = Rails.root.join("config/deploy.yml")
        return unless File.exist?(file_path)

        content = File.read(file_path)

        # Update server hostname
        if config[:server_hostname].present?
          content = content.gsub(
            /hosts:\s*\n\s*- your\.server\.ip/m,
            "hosts:\n      - #{config[:server_hostname]}"
          )
        end

        # Update domain name
        if config[:domain_name].present?
          content = content.gsub(
            /host: yourdomain\.com/,
            "host: #{config[:domain_name]}"
          )
        end

        # Update registry and image names
        if config[:registry_url].present?
          content = content.gsub(
            /image: your-registry\/your-app-name/,
            "image: #{config[:registry_url]}/#{app_slug}"
          )
        elsif config[:app_name].present?
          # If no registry provided, just update the app name in the image
          content = content.gsub(
            /image: your-registry\/your-app-name/,
            "image: your-registry/#{app_slug}"
          )
        end

        # Update service name with app name
        if config[:app_name].present?
          content = content.gsub(
            /service: your-app-name/,
            "service: #{app_slug}"
          )
        end

        File.write(file_path, content)
        Rails.logger.info "  ✓ Updated deployment configuration"
      end

      def app_slug
        config[:app_name]&.parameterize || "your-app-name"
      end
    end
  end
end
