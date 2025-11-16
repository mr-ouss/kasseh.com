# Test Suite

## Running Tests

### All Tests
```bash
bundle exec rails test
```

### With Coverage
```bash
COVERAGE=true bundle exec rails test
```

### Integration Tests with 1Password Credentials

The test suite includes integration tests for FTP and S3 operations. These tests require real credentials that are stored in 1Password.

**Run with 1Password credentials:**
```bash
op run --env-file .github/workflows/.env.test -- bundle exec rails test
```

**Run specific test files:**
```bash
# FTP batch operations
op run --env-file .github/workflows/.env.test -- bundle exec rails test test/services/file_transfer/ftp_batch_operations_test.rb

# S3 batch operations
op run --env-file .github/workflows/.env.test -- bundle exec rails test test/services/file_transfer/s3_batch_operations_test.rb
```

### Test Credentials

Test credentials are injected from 1Password using the `.github/workflows/.env.test` file:

- **S3 Test User**: `aws-test-user-1` in 1Password vault
  - `TEST_S3_ACCESS_KEY`
  - `TEST_S3_SECRET_KEY`
  - `TEST_S3_BUCKET=transferchat.ai`
  - `TEST_S3_REGION=us-east-1`

- **FTP Test User**: `ftp-test-user-1` in 1Password vault
  - `TEST_FTP_HOST=transferchat.ai`
  - `TEST_FTP_PORT=21`
  - `TEST_FTP_USERNAME`
  - `TEST_FTP_PASSWORD`

### Test Coverage

The test suite includes comprehensive coverage for:

#### Folder Operations
- **Upload Folder** (`upload_folder`)
  - FTP: Recursive directory upload with structure preservation
  - S3: Batch upload with prefix-based folders
  - Web interface with `webkitdirectory` support
  - API endpoints for programmatic access

- **Download Folder** (`download_folder`)
  - FTP: Recursive directory download
  - S3: Batch download with prefix filtering
  - ZIP archive creation for web downloads

- **Delete Folder** (`delete_folder`)
  - FTP: Recursive directory deletion
  - S3: Batch delete with pagination support
  - Confirmation dialogs in UI

- **Sync Folder** (`sync_folder`)
  - Bidirectional sync (upload/download)
  - File comparison and delta sync
  - Overwrite options

#### Controller Tests
- Web interface folder operations (`test/controllers/file_transfers_controller_batch_test.rb`)
- API v1 folder endpoints (`test/controllers/api/v1/file_transfers_batch_test.rb`)
- Activity logging and tracking
- Error handling and validation

#### Service Tests
- FTP batch operations (`test/services/file_transfer/ftp_batch_operations_test.rb`)
- S3 batch operations (`test/services/file_transfer/s3_batch_operations_test.rb`)
- Connection management
- File structure preservation
- Error scenarios

### Skipping Integration Tests

Integration tests automatically skip when credentials are not available:

```ruby
test "upload_folder uploads directory structure" do
  skip "Skipping FTP integration test" unless ftp_integration_enabled?
  # ... test code
end
```

Without 1Password credentials, these tests will show as "skipped" rather than failing.

## Test Organization

```
test/
├── controllers/
│   ├── file_transfers_controller_batch_test.rb  # Web folder operations
│   └── api/
│       └── v1/
│           └── file_transfers_batch_test.rb     # API folder operations
├── services/
│   └── file_transfer/
│       ├── ftp_batch_operations_test.rb         # FTP folder operations
│       └── s3_batch_operations_test.rb          # S3 folder operations
└── test_helper.rb                                # Credential helpers
```

## CI/CD

Tests run automatically in GitHub Actions with 1Password credentials injected. See `.github/workflows/test.yml` for configuration.
