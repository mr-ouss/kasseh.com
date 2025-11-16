# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://kasseh.com"

# Pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = "tmp/"

# Store on S3 or your preferred storage
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new

# Inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "https://kasseh.com/"

# Pick a namespace within your bucket to organize your maps
# SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"

SitemapGenerator::Sitemap.create do
  # Homepage
  add root_path, priority: 1.0, changefreq: 'weekly'

  # Static pages
  add privacy_path, priority: 0.3, changefreq: 'monthly'
  add terms_path, priority: 0.3, changefreq: 'monthly'
  add support_path, priority: 0.3, changefreq: 'monthly'

  # Future: Add blog posts
  # Article.find_each do |article|
  #   add article_path(article), lastmod: article.updated_at, priority: 0.7, changefreq: 'monthly'
  # end

  # Future: Add work/portfolio items
  # Project.find_each do |project|
  #   add project_path(project), lastmod: project.updated_at, priority: 0.8, changefreq: 'monthly'
  # end
end
