# Local CI Runner

This script runs the same checks as GitHub Actions CI locally.

## Prerequisites

- **1Password CLI** (for running tests with secrets)
  ```bash
  brew install --cask 1password-cli
  eval $(op signin)
  ```

- **bc** command (for coverage threshold calculation)
  ```bash
  brew install bc  # macOS
  ```

## Usage

Run all CI checks:
```bash
bin/ci
```

Skip tests (run only linting and security scans):
```bash
bin/ci --skip-tests
```

## What it runs

1. **Security Scan (Brakeman)** - Checks for Rails security vulnerabilities
2. **JavaScript Audit** - Scans importmap dependencies for vulnerabilities
3. **Code Linting (RuboCop)** - Ensures consistent code style
4. **Tests with Coverage** - Runs full test suite and reports coverage

## CI Jobs Mapping

| Local Command | GitHub Actions Job |
|---------------|-------------------|
| `bin/brakeman --no-pager` | `scan_ruby` |
| `bin/importmap audit` | `scan_js` |
| `bin/rubocop` | `lint` |
| `op run -- bin/rails test` | `test` |

## Tips

- Run `bin/ci` before pushing to catch issues early
- Use `--skip-tests` for quick style/security checks
- Coverage report saved to `coverage/index.html`
- Failed test screenshots saved to `tmp/screenshots/`

## Differences from GitHub CI

- **No PR comments** - GitHub CI posts coverage to PR comments
- **No artifact uploads** - Coverage reports stay local
- **Faster** - No Docker/VM overhead
- **Same results** - Uses identical commands and thresholds
