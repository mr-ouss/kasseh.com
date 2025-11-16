# RailsRocket - AI Agent Instructions

## Project Overview
RailsRocket is a production-ready Rails 8 template with authentication, OAuth, deployment, and an interactive setup wizard. It's designed to be cloned and customized for new projects.

**Key Features:**
- Interactive first-run setup wizard that configures the entire app
- Email/password + OAuth authentication (GitHub, Google, Apple)
- Kamal 2 deployment with 1Password secrets management
- SQLite multi-database (primary, cache, queue, cable)
- Solid Stack (Queue, Cache, Cable) - no Redis needed
- GitHub Actions CI/CD pipeline
- API token management
- Admin panel
- Modern UI with Hotwire/Turbo/Stimulus

## Architecture & Key Patterns

### Interactive Setup Wizard (Critical Feature)
- **First run**: Users see `/setup` wizard on first launch (development only)
- **Configuration collected**: App name, admin email, vault name, logos, theme colors, OAuth providers, deployment settings
- **Auto-updates files**: User model, vault references, landing page, README, deploy.yml, CSS variables
- **Flag file**: `.railsrocket-configured` marks setup complete (gitignored)
- **Reset command**: `rails runner "RailsRocket::Setup.reset!"` to re-run wizard

**Setup Flow:**
1. User visits http://localhost:3000
2. ApplicationController redirects to `/setup` if `.railsrocket-configured` doesn't exist
3. SetupController shows wizard form (unauthenticated access allowed)
4. On submit, ConfigUpdater modifies files in place using regex
5. Flag file created, user redirected to `/setup/complete`
6. Subsequent visits go to normal landing page

**Files involved:**
- `app/controllers/setup_controller.rb` - Wizard controller
- `app/views/setup/index.html.erb` - Wizard form
- `lib/rails_rocket/setup.rb` - Setup state management
- `lib/rails_rocket/setup/config_updater.rb` - File modification logic
- `.railsrocket-configured` - Flag file (gitignored)

### Deployment (Kamal 2)
- **Target**: Single VPS with Docker (DigitalOcean, AWS, etc.)
- **Registry**: Local image building (`localhost:5555`) - no external registry needed
- **Secrets**: 1Password CLI (`op run`) injects all secrets
- **SSH**: Uses `deploy` user (not root), configured in `config/deploy.yml`
- **Volumes**: `app_storage:/rails/storage` persists SQLite databases
- **Environment**: APP_VERSION and DEPLOYED_AT tracked in deployment

**Deploy command:**
```bash
# With 1Password vault access
op run --env-file .github/workflows/.env.deploy -- bundle exec kamal deploy

# Access production console
kamal app exec --interactive --reuse "bin/rails console"

# View logs
kamal app logs -f
```

### 1Password Integration (Secrets Management)
- **Never commit secrets** - Use `op://VaultName/ItemName/field` references
- **Setup wizard updates vault name** - Replaces "YourApp" with user's vault name
- **Required vault items**:
  - `rails-master-key` (Password)
  - `deploy-ssh-key` (SSH Key)
  - `smtp-credentials` (Login with username, password, server, from_email fields)
  - OAuth apps (if enabled): `github-oauth`, `google-oauth`, `apple-oauth`

**Pattern:**
- `.github/workflows/.env.deploy` contains `op://` references
- CI/GitHub Actions uses `OP_SERVICE_ACCOUNT_TOKEN` secret
- Local development: `eval $(op signin)` then use `op run --env-file` wrapper
- Kamal sources `.kamal/secrets` which is generated from `.env.deploy`

### Rails 8-Specific Behaviors
- **SQLite in production**: `storage/production.sqlite3` persisted via Docker volume
- **Solid Queue**: In-process job processing (`SOLID_QUEUE_IN_PUMA: true`)
- **Solid Cache**: SQLite-backed cache (no Redis)
- **Solid Cable**: SQLite-backed WebSocket connections
- **Modern browser enforcement**: `allow_browser versions: :modern` in ApplicationController
- **Import maps**: Zero-config JavaScript via `config/importmap.rb`
- **Propshaft**: Asset pipeline (not Sprockets)

### File Structure Conventions
- **Lib autoloading**: `config.autoload_lib(ignore: %w[assets tasks])` enables `lib/rails_rocket/`
- **CSS**: Single file `app/assets/stylesheets/application.css` with CSS variables
- **JS**: Stimulus controllers in `app/javascript/controllers/`
- **Setup modules**: `lib/rails_rocket/setup.rb` and `lib/rails_rocket/setup/config_updater.rb`
- **Favicon**: Direct links in layout to `/favicon-*.png` (not asset pipeline)

### Authentication & Authorization
- **Email/password**: bcrypt with secure session cookies
- **OAuth**: OmniAuth with GitHub, Google, Apple providers
- **Sessions**: Cookie-based (not session[:user_id])
- **API tokens**: SHA256 hashed, expiration support, usage tracking
- **Admin**: PRIMARY_ADMIN_EMAIL in User model gets auto-promoted
- **Concerns**: `Authentication` and `AdminAuthorization` in ApplicationController

## Local Development Commands

```bash
# Start server
bin/dev

# Reset setup wizard (development only)
rails runner "RailsRocket::Setup.reset!"

# Run tests
bin/rails test

# Run tests with coverage
COVERAGE=true bin/rails test

# Run full CI suite locally
bin/ci

# Run specific test
bin/rails test test/models/user_test.rb

# Database operations
bin/rails db:migrate
bin/rails db:seed
bin/rails db:reset

# Console
bin/rails console

# Security scan
bin/brakeman

# Linting
bin/rubocop
bin/rubocop -a  # auto-fix
```

## Testing Strategy

### Test Organization
- **Controllers**: Authentication (sessions, registrations, passwords), profiles, API tokens, admin
- **Models**: User, Session, ApiToken
- **System**: Full integration tests with Capybara
- **Fixtures**: `test/fixtures/` with realistic data
- **Coverage**: Target 70%+, configured in `.simplecov`

### Test Helpers
- **Authentication**: `sign_in_as(user)` helper in test_helper.rb
- **Fixtures**: Use `users(:one)` for test data
- **Password**: Fixture password is "password"

### Running Tests
- **Basic**: `bin/rails test` (54 tests)
- **With coverage**: `COVERAGE=true bin/rails test`
- **System tests**: `bin/rails test:system` (requires browser)
- **Single file**: `bin/rails test test/models/user_test.rb`

## Common Patterns & Gotchas

### Setup Wizard Patterns
- **File updates are regex-based**: ConfigUpdater uses `.gsub` to modify files
- **App name becomes slug**: `config[:app_name].parameterize` for deploy.yml service name
- **Logo/favicon uploads**: Saved to `app/assets/images/` and `public/`
- **CSS color updates**: Replaces `--color-accent: #[hex]` in application.css
- **Vault references**: Replaces "YourApp" in all `op://` references

### Deployment Gotchas
- **Local image building**: Kamal 2.8+ builds on deployment machine, no registry push
- **SSH key must match**: Server's `~/.ssh/authorized_keys` must have deploy user's key
- **Environment variables**: Use `env.secret` for sensitive, `env.clear` for public
- **APP_NAME**: Set as clear env var so mailers can use it
- **Volume naming**: Use `app_storage:/rails/storage` not app-specific names

### Development Gotchas
- **Setup wizard only in development**: `RailsRocket::Setup.required?` checks Rails.env.development?
- **Flag file is gitignored**: `.railsrocket-configured` won't be in repo
- **Mailer from address**: Uses `ENV.fetch("SMTP_FROM_EMAIL")` and `ENV.fetch("APP_NAME")`
- **OAuth redirect URIs**: Must match exactly in provider settings
- **Modern browser enforcement**: Old browsers get blocked by `allow_browser` filter

### Testing Gotchas
- **System tests can be flaky**: Some tests skip due to timing issues
- **Fixture password**: Always "password" for test users
- **Admin user**: `users(:admin)` fixture matches PRIMARY_ADMIN_EMAIL
- **No connections/activities**: Business models removed, tests updated to use profile/api_tokens

## Configuration Files Reference

### Key Config Files
- `config/deploy.yml` - Kamal deployment configuration
- `config/routes.rb` - Application routes (includes setup wizard)
- `config/database.yml` - SQLite multi-database configuration
- `config/initializers/omniauth.rb` - OAuth provider setup
- `config/initializers/rails_rocket.rb` - Loads setup modules
- `.env.example` - Environment variable template
- `.github/workflows/.env.deploy` - 1Password secret references
- `.kamal/secrets` - Kamal secrets template (uses variable substitution)

### Environment Variables
**Required for production:**
- `RAILS_MASTER_KEY` - Rails encryption key
- `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_SERVER`, `SMTP_FROM_EMAIL` - Email config
- `APP_NAME` - Application name (optional, defaults to "RailsRocket")

**Optional (OAuth):**
- `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`
- `APPLE_CLIENT_ID`, `APPLE_TEAM_ID`, `APPLE_KEY_ID`, `APPLE_PRIVATE_KEY`

**Deployment:**
- `KAMAL_SSH_KEY` - SSH private key for deployment
- `APP_VERSION` - Git SHA (injected by CI)
- `DEPLOYED_AT` - Deploy timestamp (injected by CI)

## When Modifying Core Features

### Adding New OAuth Provider
1. Add gem to Gemfile: `gem 'omniauth-provider'`
2. Update `config/initializers/omniauth.rb`
3. Add provider checkbox to setup wizard
4. Add credentials to `.env.example` and `.github/workflows/.env.deploy`
5. Add to User model's OAuth handling
6. Update SessionsController#oauth callback

### Adding New Setup Wizard Fields
1. Add field to `app/views/setup/index.html.erb`
2. Add to `setup_params` in SetupController
3. Add update method in ConfigUpdater
4. Call update method in `update_all!`
5. Update setup complete page with what was changed

### Modifying Deployment
1. Test locally first: `op run --env-file .github/workflows/.env.deploy -- bundle exec kamal deploy`
2. Update `config/deploy.yml` with new configuration
3. Add new secrets to `.github/workflows/.env.deploy` and 1Password vault
4. Update GitHub workflow if CI/CD changes needed
5. Document in README deployment section

### Adding New Models/Features
1. Generate with Rails: `bin/rails generate model Post title:string`
2. Add associations to User model if needed
3. Create controller and views
4. Add routes
5. Write tests (controller + model minimum)
6. Update README with new feature
7. Consider if setup wizard should configure it

## References
- Setup wizard: `app/controllers/setup_controller.rb`, `lib/rails_rocket/setup/`
- Deployment docs: `README.md` lines 271-330
- 1Password pattern: `.github/workflows/.env.deploy` and `.kamal/secrets`
- Authentication: `app/controllers/concerns/authentication.rb`
- Test helpers: `test/test_helper.rb`

## AI Coding Assistant Guidelines

When modifying this codebase:
1. **Preserve the setup wizard** - It's a core feature, don't break file update patterns
2. **Use environment variables** - Never hardcode app-specific values
3. **Test your changes** - Run `bin/rails test` before committing
4. **Follow Rails conventions** - This is a Rails 8 app, use modern patterns
5. **Keep it generic** - This is a template, not a specific application
6. **Update documentation** - README and this file when adding features
7. **Consider the user** - They'll clone this repo and customize it
8. **Don't remove OAuth** - It's a key feature, even if not all providers used
9. **Respect the .gitignore** - Don't commit secrets, databases, or flag files
10. **Maintain test coverage** - Add tests for new features
