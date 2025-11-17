# Kasseh.com

Personal website for Quentin O. Kasseh - Technology Entrepreneur, Founder, and Computer Scientist.

[![Ruby](https://img.shields.io/badge/Ruby-3.4-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.1-red.svg)](https://rubyonrails.org/)

---

## About

This is the source code for my personal website at [kasseh.com](https://kasseh.com). The site features:

- **Personal Portfolio** - Showcasing my work and professional journey
- **Writing Platform** - Blog and articles about technology, entrepreneurship, and innovation
- **Restricted Authentication** - Secure access for authorized users only
- **Modern Design** - Clean, elegant aesthetic with smooth animations

---

## Tech Stack

- **Rails 8.1** - Latest Ruby on Rails framework
- **Tailwind CSS** - Utility-first CSS framework with custom theme
- **SQLite** - Database for development and production
- **Hotwire** - Turbo and Stimulus for reactive UI
- **OAuth** - Google and Apple Sign In integration

---

## Getting Started

### Prerequisites

- Ruby 3.4+
- Node.js
- SQLite 3

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/kasseh.com.git
cd kasseh.com

# Install dependencies
bundle install

# Setup database
bin/rails db:prepare
bin/rails db:migrate

# Build Tailwind CSS
bin/rails tailwindcss:build

# Start the development server
bin/dev
```

Visit **http://localhost:3000** to see the site.

### Configuration

The site uses restricted authentication - only @kasseh.com email addresses can create accounts.

**Update the primary admin email:**

```ruby
# app/models/user.rb
PRIMARY_ADMIN_EMAIL = "your-email@kasseh.com".freeze
```

**Configure OAuth providers (optional):**

1. Set up Google OAuth credentials at [Google Cloud Console](https://console.cloud.google.com/)
2. Add credentials to Rails encrypted credentials:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

```yaml
google:
  client_id: YOUR_CLIENT_ID
  client_secret: YOUR_CLIENT_SECRET
```

---

## Project Structure

```
app/
├── controllers/
│   ├── landing_controller.rb      # Home page
│   ├── articles_controller.rb     # Blog/writing
│   ├── sessions_controller.rb     # Authentication
│   ├── legal_controller.rb        # Privacy/Terms
│   └── admin/                     # Admin panel
│
├── models/
│   ├── user.rb                    # User with OAuth & domain validation
│   ├── article.rb                 # Blog posts
│   └── session.rb                 # User sessions
│
├── views/
│   ├── landing/                   # Landing page
│   ├── articles/                  # Blog views
│   ├── sessions/                  # Login/signup
│   ├── legal/                     # Privacy, Terms, Contact
│   └── layouts/
│       └── application.html.erb
│
└── assets/
    └── tailwind/
        └── application.css        # Custom Tailwind theme
```

---

## Features

### Authentication
- Email/password authentication with bcrypt
- OAuth integration (Google, Apple)
- Domain-restricted signups (@kasseh.com only)
- Admin panel for user management
- Secure session management

### Design
- Elegant dark theme with charcoal/gold color palette
- Glass-effect cards with backdrop blur
- Smooth CSS animations
- Responsive mobile-friendly layout
- Custom Kasseh branding throughout

### Content
- Blog/writing platform with Article model
- Auto-generated slugs and reading time
- SEO optimization with meta tags
- Google Analytics integration

---

## Development

```bash
# Run tests
bin/rails test

# Build Tailwind CSS
bin/rails tailwindcss:build

# Watch Tailwind for changes
bin/rails tailwindcss:watch

# Access Rails console
bin/rails console
```

---

## Deployment

The site is configured for deployment with:
- Kamal 2 for container orchestration
- SQLite for production database
- Solid Queue for background jobs
- Thruster for HTTP caching

See `config/deploy.yml` for deployment configuration.

---

## License

This is personal website code. All content © Quentin O. Kasseh.

The underlying Rails application structure is based on modern Rails 8 conventions.

---

## Contact

- **Email**: quentin@kasseh.com
- **Twitter**: [@quentinkasseh](https://twitter.com/quentinkasseh)
- **LinkedIn**: [linkedin.com/in/quentink](https://www.linkedin.com/in/quentink)
- **Website**: [kasseh.com](https://kasseh.com)

---

Built with ❤️ using Ruby on Rails and Tailwind CSS.
