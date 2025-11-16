# 🚀 Kasseh

**Production-ready Rails 8 template with authentication, deployment, and best practices built-in.**

Skip the boilerplate. Start building your next great idea with authentication, OAuth, API tokens, deployment configuration, and a modern tech stack already set up. **AI-ready** with comprehensive GitHub Copilot instructions included.

[![Ruby](https://img.shields.io/badge/Ruby-3.4-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.1-red.svg)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📋 What's Included

### Authentication & Authorization
- ✅ **Email/Password Authentication** with bcrypt and secure password hashing
- ✅ **OAuth Integration** (GitHub, Google, Apple) via OmniAuth
- ✅ **Session Management** with secure, httponly cookies
- ✅ **Password Reset** flow with email delivery
- ✅ **Profile Management** (edit name, email, password, delete account)
- ✅ **API Tokens** with SHA256 hashing, expiration, and usage tracking
- ✅ **Admin Panel** with user management and role assignment
- ✅ **GDPR-Compliant** account deletion

### Modern Rails Stack
- ✅ **Rails 8.1** with the latest conventions and best practices
- ✅ **SQLite Multi-Database** setup (primary, cache, queue, cable)
- ✅ **Solid Queue** for background jobs (no Redis needed!)
- ✅ **Solid Cache** for caching (SQLite-backed)
- ✅ **Solid Cable** for Action Cable (optional)
- ✅ **Hotwire** (Turbo + Stimulus) for reactive UI
- ✅ **Import Maps** for zero-config JavaScript
- ✅ **Propshaft** asset pipeline

### Deployment & DevOps
- ✅ **Kamal 2 Deployment** configuration with Docker
- ✅ **1Password CLI Integration** for secrets management
- ✅ **GitHub Actions CI/CD** with automated testing and deployment
- ✅ **Multi-stage Docker builds** with optimized caching
- ✅ **Thruster** for HTTP caching and compression

### Testing & Quality
- ✅ **Minitest** with fixtures and helper methods
- ✅ **SimpleCov** for code coverage tracking
- ✅ **Capybara** for system/integration testing
- ✅ **Brakeman** security scanning
- ✅ **RuboCop** linting with Rails Omakase rules

### UI & Design
- ✅ **Modern, Responsive Design** with custom CSS
- ✅ **Dark Theme** with CSS variables
- ✅ **Glassmorphism Effects** and smooth animations
- ✅ **Mobile-Friendly** navigation and layouts
- ✅ **Clean Landing Page** showcasing template features

### Developer Experience
- ✅ **🪄 Interactive Setup Wizard** - Configure your app on first launch
- ✅ **Automatic Configuration Updates** - App name, branding, and secrets managed for you
- ✅ **Zero Manual File Editing** - The wizard updates all config files automatically
- ✅ **One-Click Branding** - Upload logo, favicon, and set theme colors
- ✅ **Vault-Agnostic** - Use your own 1Password vault name
- ✅ **🤖 AI-Ready** - Comprehensive GitHub Copilot instructions for intelligent code assistance

---

## 🚀 Quick Start

### Prerequisites

- **Ruby 3.4+** (recommended: use [mise](https://mise.jdx.dev/) or rbenv)
- **Node.js** (for JavaScript dependencies)
- **SQLite 3** (usually pre-installed on macOS/Linux)
- **Docker** (optional, for deployment)
- **1Password CLI** (optional, for secrets management)

### Installation

**Step 1: Clone Kasseh template**

```bash
# Clone the Kasseh template
git clone https://github.com/Syntaxia/Kasseh.git
```

**Step 2: Create your new app repository**

```bash
# Create a new directory for your app
mkdir my_app
cd my_app

# Initialize a fresh git repository
git init
```

**Step 3: Copy template files to your app**

```bash
# Copy all files from Kasseh to your app (excluding .git)
rsync -av --exclude='.git' ../Kasseh/ .

# Or on Windows (PowerShell):
# Copy-Item -Path ..\Kasseh\* -Destination . -Recurse -Exclude .git

# Verify files were copied
ls -la
```

**Step 4: Install dependencies and setup**

**Option A: One command (Quick Start)**

```bash
rsync -av --exclude='.git' ../Kasseh/ . && bundle install && bin/rails db:prepare && bin/rails db:migrate && bin/dev
```

**Option B: Step by step**

```bash
# Install Ruby dependencies
bundle install

# Setup database
bin/rails db:prepare

# Run database migrations
bin/rails db:migrate

# Start the development server
bin/dev
```

Visit **http://localhost:3000** and you'll be greeted by the **interactive setup wizard**! 🧙‍♂️

**Step 5: Make your first commit**

After completing the setup wizard, commit your configured app:

```bash
git add -A
git commit -m "Initial commit: Kasseh template configured for MyApp"

# Optional: Add your remote repository
git remote add origin https://github.com/yourusername/my_app.git
git push -u origin master
```

### 🪄 Interactive Setup Wizard

The first time you run Kasseh, you'll be redirected to `/setup` where you can configure:

- **Application Name** - Updates throughout your codebase
- **Primary Admin Email** - Your admin account
- **1Password Vault Name** - For secrets management
- **Logo & Favicon** - Custom branding (optional)
- **Theme Colors** - Customize the look (optional)
- **OAuth Providers** - Enable GitHub, Google, or Apple sign-in

The wizard automatically updates:
- ✅ User model with your admin email
- ✅ All 1Password vault references
- ✅ Landing page and branding
- ✅ README and configuration files
- ✅ Theme colors in CSS

**After setup completes**, the wizard is disabled and you won't see it again. To re-run setup:

```bash
rails runner "Kasseh::Setup.reset!"
bin/dev
```

### 🤖 AI-Ready Development

Kasseh includes comprehensive **GitHub Copilot instructions** (`.github/copilot-instructions.md`) that help AI coding assistants understand your codebase architecture and patterns.

**What's included:**
- 📚 Complete architecture overview and key patterns
- 🔧 Setup wizard implementation details
- 🚀 Deployment and 1Password integration guides
- 🧪 Testing strategies and helpers
- ⚠️ Common gotchas and how to avoid them
- 📝 Step-by-step guides for adding features
- 🎯 AI coding assistant guidelines

**Benefits:**
- **Smarter code suggestions** - Copilot understands your setup wizard patterns, deployment config, and authentication flows
- **Faster development** - AI assistance that knows Rails 8, Solid Stack, and Kamal 2 specifics
- **Better refactoring** - Context-aware suggestions that preserve your template architecture
- **Consistent patterns** - AI follows your established conventions automatically

No configuration needed - just start coding and your AI assistant will be fully informed!

---

## 📖 Usage Guide

### Creating Your First User

After completing the setup wizard:

1. Click "Get Started" or "Create Account" on the landing page
2. Fill in your email and password
3. You're logged in! Visit your profile to update details.

**Pro tip:** Use the email you set as PRIMARY_ADMIN_EMAIL to get automatic admin privileges.

### Using OAuth (GitHub, Google, Apple)

Before using OAuth, you need to configure your OAuth app credentials:

1. Create OAuth apps for the providers you want:
   - **GitHub**: https://github.com/settings/developers
   - **Google**: https://console.cloud.google.com/apis/credentials
   - **Apple**: https://developer.apple.com/account/resources/identifiers/list

2. Update `config/initializers/omniauth.rb` with your credentials:

```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    ENV.fetch("GITHUB_CLIENT_ID", "your_github_client_id"),
    ENV.fetch("GITHUB_CLIENT_SECRET", "your_github_client_secret"),
    scope: "user:email"

  provider :google_oauth2,
    ENV.fetch("GOOGLE_CLIENT_ID", "your_google_client_id"),
    ENV.fetch("GOOGLE_CLIENT_SECRET", "your_google_client_secret"),
    scope: "email,profile"

  provider :apple,
    ENV.fetch("APPLE_CLIENT_ID", "your_apple_client_id"),
    ENV.fetch("APPLE_TEAM_ID", "your_apple_team_id"),
    {
      scope: "email name",
      team_id: ENV.fetch("APPLE_TEAM_ID"),
      key_id: ENV.fetch("APPLE_KEY_ID"),
      pem: ENV.fetch("APPLE_PRIVATE_KEY")
    }
end
```

3. Set environment variables or use 1Password for secrets management.

### Admin Panel

The first user with the email defined in `PRIMARY_ADMIN_EMAIL` (in `app/models/user.rb`) will automatically be promoted to admin.

**Update the primary admin email:**

```ruby
# app/models/user.rb
PRIMARY_ADMIN_EMAIL = "your-email@example.com".freeze
```

**Admin features:**
- View all users at `/admin/users`
- Promote/demote users to admin
- Delete user accounts (except primary admin)
- View user details and activity

### API Tokens

Users can create API tokens for programmatic access:

1. Log in and visit `/api_tokens`
2. Click "Create New Token"
3. Give it a name and optional expiration date
4. Copy the token (shown only once!)
5. Use in API requests: `Authorization: Bearer YOUR_TOKEN`

---

## ⚙️ Configuration

### Environment Variables

Create a `.env` file for local development (add to `.gitignore`):

```bash
# OAuth Credentials
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret

GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

APPLE_CLIENT_ID=your_apple_client_id
APPLE_TEAM_ID=your_apple_team_id
APPLE_KEY_ID=your_apple_key_id
APPLE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"

# Email Configuration (optional)
SMTP_SERVER=smtp.example.com
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password

# Application Settings
APP_NAME="Kasseh"
APP_DOMAIN="example.com"
```

### Customizing the App Name

**The interactive setup wizard handles all app customization automatically!** When you first run the app at http://localhost:3000, you'll be guided through:

- Setting your app name (updates landing page, README, configs)
- Setting your admin email (updates User model)
- Configuring your 1Password vault name (updates all references)
- Uploading logo and favicon (optional)
- Setting theme colors (optional)
- Configuring deployment settings (optional)

**To manually re-customize after setup:**

```bash
# Reset the setup wizard to run again
rails runner "Kasseh::Setup.reset!"

# Then restart your server
bin/dev
```

Or manually update these files:
- `app/models/user.rb` - PRIMARY_ADMIN_EMAIL
- `app/views/landing/index.html.erb` - Branding
- `config/deploy.yml` - Deployment configuration
- `.github/workflows/.env.deploy` - 1Password vault references

### Email Configuration

For password reset emails, configure SMTP in `config/environments/production.rb`:

```ruby
config.action_mailer.smtp_settings = {
  address: ENV["SMTP_SERVER"],
  port: 587,
  user_name: ENV["SMTP_USERNAME"],
  password: ENV["SMTP_PASSWORD"],
  authentication: "login",
  enable_starttls_auto: true
}
```

In development, emails are logged to the console (not sent).

---

## 🚢 Deployment

### GitHub Actions Secrets Setup

**IMPORTANT:** For CI/CD deployment to work, you must configure a GitHub repository secret.

Kasseh uses **1Password** for secrets management in GitHub Actions. This allows your deployment workflow to securely access credentials (database keys, API keys, OAuth secrets, etc.) without storing them in your repository.

**Step 1: Create a 1Password Service Account Token**

1. Log in to your [1Password account](https://1password.com/)
2. Go to **Settings** → **Developer** → **Service Accounts**
3. Click **Create Service Account**
4. Give it a descriptive name (e.g., "GitHub Actions - MyApp")
5. Grant it **Read** access to your vault (the vault you configured in the setup wizard)
6. Copy the **Service Account Token** (starts with `ops_`)

**Step 2: Add Secret to GitHub Repository**

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `OP_SERVICE_ACCOUNT_TOKEN`
5. Value: Paste your service account token from Step 1
6. Click **Add secret**

**What this enables:**
- ✅ GitHub Actions can access secrets from your 1Password vault during deployment
- ✅ Automated deployments via `git push` to master branch
- ✅ No credentials stored in your repository or workflow files
- ✅ Centralized secret management in 1Password

**Note:** Without this secret configured, the deployment workflow will skip automatically (this prevents the Kasseh template repository from trying to deploy).

### Using Kamal 2

Kasseh includes a production-ready Kamal configuration.

**Prerequisites:**
- Docker installed locally
- A VPS (DigitalOcean, AWS, etc.) with Docker installed
- SSH access to the server
- 1Password CLI (required for deployment)

**Setup:**

1. **Update `config/deploy.yml`:**

```yaml
service: your-app-name
image: your-docker-registry/your-app-name

servers:
  web:
    hosts:
      - your.server.ip

proxy:
  ssl: true
  host: yourdomain.com

env:
  secret:
    - RAILS_MASTER_KEY
    - SMTP_USERNAME
    - SMTP_PASSWORD
    # Add more secrets as needed
```

2. **Deploy:**

```bash
# Initial setup (first time only)
kamal setup

# Deploy updates
kamal deploy

# View logs
kamal app logs -f

# Access console
kamal app exec --interactive --reuse "bin/rails console"
```

### Using Other Platforms

Kasseh is a standard Rails app and can be deployed to:
- **Heroku**: Add `Procfile` and use Heroku Postgres
- **Fly.io**: Use included `Dockerfile`
- **Render**: Connect GitHub repo and configure environment
- **AWS/GCP**: Deploy as Docker container

---

## 🧪 Testing

```bash
# Run all tests
bin/rails test

# Run with coverage
COVERAGE=true bin/rails test

# Run specific test file
bin/rails test test/models/user_test.rb

# Run system tests (with browser)
bin/rails test:system
```

**Test Coverage:**
- Minimum coverage: 30% (configurable in `.simplecov`)
- Maximum coverage drop: 20%
- HTML reports in `coverage/index.html`

---

## 🏗️ Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── sessions_controller.rb       # Login/logout
│   ├── registrations_controller.rb  # Sign up
│   ├── passwords_controller.rb      # Password reset
│   ├── profiles_controller.rb       # User profile
│   ├── api_tokens_controller.rb     # API token management
│   ├── landing_controller.rb        # Home page
│   ├── legal_controller.rb          # Privacy/Terms/Support
│   ├── admin/
│   │   ├── dashboard_controller.rb  # Admin dashboard
│   │   └── users_controller.rb      # User management
│   └── concerns/
│       ├── authentication.rb        # Session helpers
│       ├── admin_authorization.rb   # Admin-only filter
│       └── authentication/
│           └── api_token.rb         # API token auth
│
├── models/
│   ├── user.rb                      # User with OAuth
│   ├── session.rb                   # User sessions
│   ├── api_token.rb                 # API tokens
│   └── current.rb                   # Request-scoped user
│
├── views/
│   ├── landing/                     # Landing page
│   ├── sessions/                    # Login/OAuth
│   ├── registrations/               # Sign up
│   ├── profiles/                    # Profile management
│   ├── passwords/                   # Password reset
│   ├── api_tokens/                  # API tokens
│   ├── admin/                       # Admin panel
│   ├── shared/                      # Partials
│   └── layouts/
│       └── application.html.erb     # Main layout
│
├── javascript/
│   └── controllers/
│       ├── auth_modal_controller.js
│       ├── mobile_menu_controller.js
│       └── collapsible_controller.js
│
└── mailers/
    ├── application_mailer.rb
    ├── account_mailer.rb           # Account notifications
    └── passwords_mailer.rb         # Password reset

config/
├── deploy.yml                      # Kamal deployment
├── routes.rb                       # Application routes
├── database.yml                    # SQLite multi-DB
├── initializers/
│   ├── omniauth.rb                # OAuth providers
│   └── active_record_encryption.rb
└── environments/
    ├── development.rb
    ├── test.rb
    └── production.rb

.github/
└── workflows/
    └── ci.yml                      # GitHub Actions CI

test/
├── controllers/                    # Controller tests
├── models/                         # Model tests
├── system/                         # Integration tests
├── fixtures/                       # Test data
└── test_helper.rb                  # Test configuration
```

---

## 🎨 Customization

### Changing the Theme

The app uses CSS variables for theming. Update in `app/assets/stylesheets/application.css`:

```css
:root {
  --color-bg: #020617;              /* Background */
  --color-surface: rgba(15, 23, 42, 0.8);  /* Panels */
  --color-text: #f8fafc;            /* Text */
  --color-muted: #cbd5f5;           /* Muted text */
  --color-accent: #38bdf8;          /* Primary color */
  --color-accent-dark: #0ea5e9;     /* Hover state */
  --color-border: rgba(148, 163, 184, 0.28);
}
```

### Adding New Features

```bash
# Generate a new model
bin/rails generate model Post title:string body:text user:references

# Generate a new controller
bin/rails generate controller Posts index show new create

# Generate a new Stimulus controller
bin/rails generate stimulus posts
```

---

## 📚 Documentation

- **[Rails Guides](https://guides.rubyonrails.org/)** - Official Rails documentation
- **[Hotwire](https://hotwired.dev/)** - Turbo and Stimulus guides
- **[Kamal](https://kamal-deploy.org/)** - Deployment guide
- **[1Password CLI](https://developer.1password.com/docs/cli/)** - Secrets management

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with ❤️ by the team at [Syntaxia](https://www.syntaxia.com).

Special thanks to:
- The Ruby on Rails team for an amazing framework
- The Hotwire team for making SPAs simple again
- The Kamal team for revolutionizing Rails deployment

---

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/Syntaxia/Kasseh/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Syntaxia/Kasseh/discussions)
- **Email**: support@syntaxia.com

---

**Happy coding! 🚀**
