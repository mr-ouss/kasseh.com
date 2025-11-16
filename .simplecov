# SimpleCov configuration
SimpleCov.start "rails" do
  # Coverage output directory
  coverage_dir "coverage"

  # Exclude these paths from coverage
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/script/"

  # Group files by type for better organization
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Mailers", "app/mailers"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", "app/jobs"
  add_group "Channels", "app/channels"

  # Set minimum coverage threshold (will increase as we add more tests)
  SimpleCov.minimum_coverage 30
  # Don't require minimum coverage per file (some files won't be fully tested yet)
  # minimum_coverage_by_file 40

  # Fail build if coverage drops by more than 20%
  maximum_coverage_drop 20

  # Track code added since last run
  track_files "{app,lib}/**/*.rb"

  # Merge results from parallel test runs
  use_merging true
  merge_timeout 600
end
