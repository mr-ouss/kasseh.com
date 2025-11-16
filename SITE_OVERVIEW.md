# Quentin Kasseh Personal Brand Website

## Overview
A sophisticated, elegant personal website built with Rails 8.1, featuring a cinematic Three.js hero animation, blog system, and modern design aesthetic.

## What's Been Built

### ✅ Design System
- **Color Palette**: Sophisticated monochromatic charcoal palette with gold accents
  - Primary: Charcoal (#1a1a1f - #f7f7f8)
  - Accent: Gold (#d4a962)
- **Typography**:
  - Headings: Playfair Display (serif)
  - Body: Inter (sans-serif)
  - Custom responsive font sizes
- **Components**: Buttons, cards, links with elegant hover states
- **Utilities**: Glass effect, animations, custom containers

### ✅ Landing Page
- **Hero Section**:
  - Three.js particle animation (1000 particles)
  - Mouse-responsive 3D rotation
  - Smooth animations and breathing effects
  - Glass-morphism navigation bar
  - Scroll indicator
- **Content Sections**:
  - About section
  - Writing section (links to blog)
  - Work/portfolio placeholder
  - Contact section with social links
- **Footer**: Dynamic year, legal links

### ✅ Blog/Writing System
- **Article Model**:
  - Fields: title, slug, content, excerpt, published_at, featured, meta_description, author, reading_time
  - Auto-generated slugs from titles
  - Auto-calculated reading time
  - Auto-generated excerpts
  - Published/featured scopes
- **Pages**:
  - Articles index with featured section
  - Individual article pages
  - SEO-optimized with Article structured data
- **Routes**: `/articles` (index), `/articles/:slug` (show)

### ✅ SEO & Performance
- Open Graph meta tags
- Twitter Card support
- Semantic HTML5
- Structured data (Article schema)
- Sitemap.xml configuration
- robots.txt
- Responsive images support
- Turbo for SPA-like performance

### ✅ Technical Stack
- Rails 8.1.0
- Ruby 3.4
- SQLite3 (development & production)
- Tailwind CSS v4 with custom theme
- Three.js for 3D animations
- Stimulus controllers
- Turbo for navigation
- Importmap for JavaScript

## File Structure

```
app/
├── assets/
│   └── tailwind/
│       └── application.css          # Tailwind config with custom theme
├── controllers/
│   ├── articles_controller.rb       # Blog controller
│   └── landing_controller.rb        # Homepage controller
├── javascript/
│   └── controllers/
│       └── hero_animation_controller.js  # Three.js animation
├── models/
│   └── article.rb                   # Article model with validations
└── views/
    ├── articles/
    │   ├── index.html.erb           # Blog index
    │   └── show.html.erb            # Article detail
    ├── landing/
    │   └── index.html.erb           # Homepage
    └── layouts/
        └── application.html.erb     # Main layout with SEO meta tags
```

## Next Steps

### Immediate
1. **Replace Placeholder Logo**: Add actual signet/logo image to [landing/index.html.erb:23](/Users/kasseh/Projects/Personal Utilities/kasseh.com/app/views/landing/index.html.erb#L23)
2. **Update Social Links**: Replace placeholder URLs in footer with actual social media profiles
3. **Create First Article**: Use Rails console or create admin interface to publish first post
4. **Add OG Image**: Create and add Open Graph image for social sharing

### Admin Interface (Recommended)
Create an admin interface for managing articles:
```ruby
# Generate admin articles controller
rails g controller Admin::Articles index new create edit update destroy

# Add authentication check
# Add form for creating/editing articles
# Add rich text editor (Action Text or Trix)
```

### Content
1. **About Page**: Expand the about section with more personal details
2. **Work/Portfolio**: Add project showcases
3. **Blog Posts**: Start writing and publishing articles
4. **Images**: Add professional photos and project screenshots

### Enhancements
1. **Dark Mode**: Add theme toggle
2. **Mobile Menu**: Implement hamburger navigation for mobile
3. **Image Optimization**: Set up Active Storage with variants
4. **RSS Feed**: Add RSS for blog subscribers
5. **Search**: Implement article search functionality
6. **Tags/Categories**: Add taxonomy for articles
7. **Analytics**: Configure Google Analytics tracking ID
8. **Email Newsletter**: Integrate with email service

## Running the Site

### Development
```bash
# Install dependencies
bundle install

# Run migrations
bin/rails db:migrate

# Start development server with Tailwind watcher
bin/dev

# Or run separately:
bin/rails server
bin/rails tailwindcss:watch
```

### Creating Articles
```ruby
# In Rails console (rails c)
Article.create!(
  title: "My First Article",
  content: "This is the full content of my article...",
  published_at: Time.current,
  featured: true,
  author: "Quentin Kasseh"
)
```

### Building for Production
```bash
# Build Tailwind CSS
bin/rails tailwindcss:build

# Generate sitemap
bin/rails sitemap:refresh

# Deploy with Kamal
kamal deploy
```

## Design Philosophy
- **Disciplined**: Clean layouts, generous whitespace, clear hierarchy
- **Elegant**: Sophisticated typography, subtle animations, refined color palette
- **Cinematic**: Three.js animation creates atmospheric, movie-like quality
- **Performance**: Optimized for fast loading, smooth transitions
- **SEO-First**: Structured data, semantic HTML, comprehensive meta tags

## Browser Support
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile responsive (320px+)
- Three.js animation gracefully degrades on older devices

## Notes
- Signet logo placeholder is currently a gradient circle
- Social links need to be updated with actual URLs
- Google Analytics tracking ID should be updated in layout
- Images for og:image should be added to assets

## Support
For questions or customization needs, refer to:
- [Rails Guides](https://guides.rubyonrails.org/)
- [Tailwind CSS v4 Docs](https://tailwindcss.com/docs)
- [Three.js Documentation](https://threejs.org/docs/)
