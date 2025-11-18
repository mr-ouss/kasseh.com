# GitHub Copilot Instructions for Kasseh.com

## Project Overview

This is the personal website for Quentin O. Kasseh - a Rails 8.1 application with restricted authentication, blog functionality, and elegant dark-themed design.

**Primary Purpose**: Personal portfolio and writing platform with secure, invite-only access.

**Tech Stack**:
- Rails 8.1
- Tailwind CSS v4 with custom theme
- SQLite (development & production)
- Hotwire (Turbo + Stimulus)
- OAuth (Google & Apple)

---

## Architecture Patterns

### Authentication & Authorization

**Domain-Restricted Signups**:
- Only @kasseh.com email addresses can create accounts
- Primary admin email defined in `User::PRIMARY_ADMIN_EMAIL`
- Email validation enforced at model level with regex: `/@kasseh\.com\z/i`
- Family members directed to support@kasseh.com for assistance

**OAuth Integration**:
- Providers: Google OAuth2, Apple Sign In
- Configured in `config/initializers/omniauth.rb`
- Credentials stored in Rails encrypted credentials
- User model handles OAuth callback with `find_or_create_from_auth` method

**Session Management**:
- `Current.user` pattern for request-scoped user access
- `Authentication` concern in ApplicationController
- Sessions stored in database with `has_many :sessions`

### Styling & Design

**Tailwind CSS v4**:
- Configuration in `app/assets/tailwind/application.css` using `@theme` directive
- Custom color palette: charcoal (dark grays) + gold (accent)
- CSS variables defined in `@theme` block, not traditional config file
- Glass-effect cards: `bg-white/10 backdrop-blur-md border border-charcoal-700/50`

**Color Palette**:
```css
--color-charcoal-900: #1a1a1f  /* Dark background */
--color-charcoal-800: #2a2a31  /* Slightly lighter */
--color-charcoal-200: #d9d9de  /* Light text */
--color-gold-600: #c58d47      /* Primary accent */
--color-gold-500: #d4a962      /* Hover state */
```

**Design Principles**:
- Dark gradient backgrounds: `bg-gradient-to-br from-charcoal-900 via-charcoal-800 to-charcoal-900`
- Sans-serif fonts for UI (KASSEH branding), serif for content
- Smooth transitions: `transition-colors duration-300`
- Consistent spacing with Tailwind utilities

### Content Management

**Articles (Blog Posts)**:
- Auto-generated slugs from titles (parameterized)
- Reading time calculation based on word count
- Auto-generated excerpts from content
- Published/draft state with `published_at` timestamp
- Scopes: `published`, `featured`, `recent`

**SEO Optimization**:
- Open Graph meta tags in layout
- Twitter Card meta tags
- Dynamic titles with `content_for :title`
- Google Analytics integration (G-NFCW4B7LWG)

---

## Key Files & Their Purposes

### Models

**`app/models/user.rb`**:
- Central authentication model
- PRIMARY_ADMIN_EMAIL constant - update this for admin access
- OAuth methods: `find_or_create_from_auth`, `oauth_user?`, `email_to_name`
- Email domain validation (must be @kasseh.com)
- Admin flag management with `set_primary_admin_flag` callback

**`app/models/article.rb`**:
- Blog post model with slug, reading time, excerpt auto-generation
- Validations ensure required fields
- Callbacks populate computed fields before validation

**`app/models/current.rb`**:
- Request-scoped user storage (thread-safe)
- Used throughout app for current user access

### Controllers

**`app/controllers/concerns/authentication.rb`**:
- Session helpers: `authenticated?`, `require_authentication`
- Login/logout methods
- Current user access

**`app/controllers/sessions_controller.rb`**:
- Handles email/password login
- OAuth callback handling via `oauth` action
- Session creation/destruction

**`app/controllers/legal_controller.rb`**:
- Privacy, Terms, Contact (Support) pages
- All use same dark aesthetic as auth pages

### Views

**Authentication Pages**:
- Consistent branding: KASSEH logo + "KASSEH" text
- Dark gradient background with glass-effect cards
- Gold accents for links and buttons
- Family member support message on signup

**Legal Pages** (`app/views/legal/*`):
- Terms, Privacy, Support all use same dark template
- Self-contained with logo, content card, footer
- No separate header/footer partials needed
- "Back to home" navigation at bottom

**Landing Page** (`app/views/landing/index.html.erb`):
- Animated gradient background with CSS keyframes
- Grid pattern overlay for subtle texture
- Centered layout with social links
- Footer with Privacy/Terms links

### Styling

**`app/assets/tailwind/application.css`**:
- Google Fonts import (Playfair Display, Inter)
- `@theme` configuration with color/font variables
- Custom component classes in `@layer components`
- Prose styles for content

---

## Common Development Tasks

### Adding New Legal/Content Pages

**Pattern to follow**:
```erb
<% content_for :title, "Page Title · Kasseh" %>
<% content_for :skip_navigation, true %>
<% content_for :body_class, "auth-page-body" %>

<div class="min-h-screen bg-gradient-to-br from-charcoal-900 via-charcoal-800 to-charcoal-900 px-4 py-12">
  <div class="max-w-4xl mx-auto">
    <!-- Logo -->
    <div class="text-center mb-12">
      <%= link_to root_path, class: "inline-block" do %>
        <%= image_tag "kasseh-logo.png", alt: "Kasseh", class: "w-16 h-16 mx-auto opacity-90 hover:opacity-100 transition-opacity duration-300 mb-4" %>
        <h2 class="text-xl font-sans font-bold text-white tracking-wide">KASSEH</h2>
      <% end %>
    </div>

    <!-- Content Card -->
    <div class="bg-white/10 backdrop-blur-md border border-charcoal-700/50 rounded-lg shadow-2xl p-8 md:p-12 mb-8">
      <!-- Your content here -->
    </div>

    <!-- Back to home & Footer -->
  </div>
</div>
```

### Adding New Article/Blog Post

```ruby
# In rails console or seed file
Article.create!(
  title: "My Article Title",
  content: "Article content here...",
  author: "Quentin Kasseh",
  published_at: Time.current,  # or nil for draft
  featured: false
)
```

### Updating Branding

**Logo**: Replace `app/assets/images/kasseh-logo.png` (main) and `kasseh-logo-small.png` (footer)

**Site Name**: Update "KASSEH" text in:
- Auth pages (login, signup, password reset)
- Legal pages (terms, privacy, support)
- Any new pages

**Colors**: Modify `@theme` variables in `app/assets/tailwind/application.css`

### OAuth Configuration

**Google OAuth**:
1. Get credentials from Google Cloud Console
2. Add to Rails credentials: `EDITOR="code --wait" bin/rails credentials:edit`
```yaml
google:
  client_id: YOUR_CLIENT_ID
  client_secret: YOUR_CLIENT_SECRET
```
3. Update callback URL in Google Console: `http://localhost:3000/auth/google_oauth2/callback`

**Apple Sign In**:
- Similar process with Apple Developer portal
- Requires additional setup (team ID, key ID, private key)

---

## Important Conventions

### Email Validation
- **ALWAYS** enforce @kasseh.com domain restriction
- Exception: PRIMARY_ADMIN_EMAIL can be any email
- Validation in User model, not controller

### Typography
- **Branding**: `font-sans font-bold tracking-wide` for "KASSEH"
- **Headings**: `font-sans font-bold` for page titles
- **Body**: `text-charcoal-200 leading-relaxed` for readable text
- **Links**: `text-gold-500 hover:text-gold-400 transition-colors underline`

### Forms
- Glass-effect background: `bg-white/10`
- Gold focus rings: `focus:ring-2 focus:ring-gold-500`
- Error states: `bg-red-500/20 border-red-500/50 text-red-200`
- Success states: `bg-green-500/20 border-green-500/50 text-green-200`

### Navigation
- Skip navigation on auth/legal pages: `content_for :skip_navigation, true`
- Body class for consistent styling: `content_for :body_class, "auth-page-body"`
- Always include "Back to home" on standalone pages

---

## Things to Avoid

❌ **Don't** allow signups without @kasseh.com validation
❌ **Don't** use serif fonts for UI elements (only content uses serif)
❌ **Don't** add GitHub OAuth (removed intentionally)
❌ **Don't** use old Tailwind config patterns (use `@theme` directive)
❌ **Don't** hardcode colors (use Tailwind utility classes)
❌ **Don't** create public signup flows (registration is restricted)
❌ **Don't** skip the family support message on signup page
❌ **Don't** use RailsRocket or template branding anywhere

---

## Testing

**Key test files**:
- `test/models/user_test.rb` - User model, OAuth, admin logic
- `test/models/article_test.rb` - Article validation, slug generation
- `test/controllers/sessions_controller_test.rb` - Auth flows
- `test/system/authentication_test.rb` - End-to-end login/signup

**Run tests**:
```bash
bin/rails test                    # All tests
bin/rails test:system             # System tests only
COVERAGE=true bin/rails test      # With coverage report
```

---

## Deployment

- Configured for Kamal 2 deployment
- SQLite in production (via Solid Stack)
- Solid Queue for background jobs
- Environment variables in `.env` (development) or Rails credentials (production)

---

## Support & Contact

- Email: support@kasseh.com (for family member account requests)
- Privacy: legal@kasseh.com
- General: quentin@kasseh.com

---

## Quick Reference

**Admin User**: First user with PRIMARY_ADMIN_EMAIL gets admin flag automatically

**Color Classes**:
- `charcoal-900/800/200` - Backgrounds and text
- `gold-600/500/400` - Accents and links

**Glass Effect**: `bg-white/10 backdrop-blur-md border border-charcoal-700/50`

**Gradient BG**: `bg-gradient-to-br from-charcoal-900 via-charcoal-800 to-charcoal-900`

**Typography Scale**:
- Logo: `text-xl font-sans font-bold tracking-wide`
- H1: `text-3xl md:text-4xl font-sans font-bold`
- H2: `text-2xl font-sans font-bold`
- H3: `text-xl font-sans font-semibold`
- Body: `text-charcoal-200 leading-relaxed`

---

## AI Coding Assistant Guidelines

When working on this codebase:

1. **Preserve domain restrictions** - @kasseh.com email validation is critical
2. **Maintain consistent styling** - Follow the dark theme patterns
3. **Test your changes** - Run `bin/rails test` before committing
4. **Follow Rails 8 conventions** - Use modern Rails patterns
5. **Keep branding consistent** - "KASSEH" in sans-serif, gold accents
6. **Update documentation** - Keep README current with changes
7. **Respect privacy** - This is a personal site, not a template
8. **Don't commit secrets** - Use Rails credentials for sensitive data
9. **Maintain test coverage** - Add tests for new features
10. **Consider mobile** - Ensure responsive design for all new pages
