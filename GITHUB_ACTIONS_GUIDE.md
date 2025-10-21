# GitHub Actions CI/CD Pipeline Guide

## 📋 Overview

Your CI/CD pipeline automatically tests and validates your Django application on every push and pull request to the `main` branch.

**Pipeline File:** `.github/workflows/ci.yml`  
**Trigger Events:** Push to main, Pull requests to main  
**Runner:** Ubuntu Latest  
**Python Version:** 3.12

---

## 🔄 Current Pipeline Workflow

### Pipeline Steps:

1. **Checkout Code** (`actions/checkout@v4`)
   - Clones your repository to the runner

2. **Set Up Python** (`actions/setup-python@v5`)
   - Installs Python 3.12
   - Configures pip cache

3. **Install Dependencies**
   - Upgrades pip
   - Installs packages from `requirements.txt`

4. **Run Tests** (`python manage.py test`)
   - ✅ **NOW INCLUDES:** 10 actual test cases
   - Tests homepage functionality
   - Tests URL routing
   - Tests template rendering

5. **Check for Syntax Errors** (`python manage.py check`)
   - Django system check framework
   - Validates configuration
   - Checks for common issues

---

## 🧪 Test Coverage

### Current Tests (`core/tests.py`)

**HomeViewTests** (8 tests):
- ✅ `test_home_page_status_code` - HTTP 200 response
- ✅ `test_home_page_uses_correct_template` - Template validation
- ✅ `test_home_page_contains_welcome_message` - Content check
- ✅ `test_home_page_contains_bootstrap` - Bootstrap integration
- ✅ `test_home_page_title` - Page title
- ✅ `test_home_page_has_navbar` - Navigation bar

**URLTests** (2 tests):
- ✅ `test_home_url_resolves` - URL routing
- ✅ `test_admin_url_accessible` - Admin panel

---

## 🚀 Testing Your Pipeline

### Option 1: Push to GitHub (Automatic Trigger)

```bash
# Navigate to project (WSL environment)
cd /home/bamideleflint/Django-App/Django_Project

# Stage all changes
git add .

# Commit with descriptive message
git commit -m "feat: Add comprehensive test suite for CI/CD pipeline

- Add 10 test cases for home view and URL routing
- Test HTTP responses, templates, and content
- Validate Bootstrap integration and navbar
- Enable meaningful CI/CD validation"

# Push to main branch (triggers CI)
git push origin main
```

### Option 2: Create a Pull Request

```bash
# Create feature branch
git checkout -b add-tests

# Make changes and commit
git add .
git commit -m "feat: Add test suite"

# Push to feature branch
git push origin add-tests

# Create PR on GitHub (triggers CI)
```

### Option 3: Manual Trigger (Add to ci.yml)

Add `workflow_dispatch` to your triggers:

```yaml
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  workflow_dispatch:  # ← Add this for manual triggers
```

---

## 📊 Viewing Pipeline Results

### On GitHub:

1. **Navigate to Repository** → `Actions` tab
2. **View Workflows** → Click on latest run
3. **Inspect Steps** → Expand each step to see logs
4. **Check Status:**
   - ✅ Green checkmark = Success
   - ❌ Red X = Failure
   - 🟡 Yellow dot = In progress

### Pipeline Logs Show:

```
Run python manage.py test
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
..........
----------------------------------------------------------------------
Ran 10 tests in 0.045s

OK
Destroying test database for alias 'default'...
```

---

## 🔍 Local Testing (Before Pushing)

**Always test locally first to avoid breaking the pipeline!**

### Run All Tests:

```bash
cd /home/bamideleflint/Django-App/Django_Project
python manage.py test
```

### Run Specific Test Class:

```bash
python manage.py test core.tests.HomeViewTests
```

### Run Single Test:

```bash
python manage.py test core.tests.HomeViewTests.test_home_page_status_code
```

### Run with Verbose Output:

```bash
python manage.py test --verbosity=2
```

### Run Django Check:

```bash
python manage.py check
```

---

## 🐛 Troubleshooting Failed Pipelines

### Common Issues & Solutions

#### Issue 1: Tests Fail
**Error:** `FAILED (failures=X)`

**Solution:**
```bash
# Run tests locally to see detailed error
python manage.py test --verbosity=2

# Fix the failing test
# Re-run locally
# Push again
```

#### Issue 2: Dependency Installation Fails
**Error:** `ERROR: Could not find a version that satisfies...`

**Solution:**
```bash
# Check requirements.txt is up to date
pip freeze > requirements.txt

# Ensure compatibility
pip install -r requirements.txt

# Commit and push
git add requirements.txt
git commit -m "fix: Update requirements.txt"
git push
```

#### Issue 3: Django Check Fails
**Error:** `SystemCheckError: System check identified some issues`

**Solution:**
```bash
# Run check locally
python manage.py check

# Fix reported issues
# Common fixes:
# - Add ALLOWED_HOSTS
# - Fix INSTALLED_APPS
# - Correct DATABASES config
```

#### Issue 4: SECRET_KEY Issues (Future)
**Error:** `django.core.exceptions.ImproperlyConfigured: The SECRET_KEY setting must not be empty.`

**Solution:**
```yaml
# Add to ci.yml under 'Run tests' step:
- name: Run tests
  env:
    SECRET_KEY: 'test-secret-key-for-ci'
    DEBUG: 'True'
  run: |
    python manage.py test
```

---

## 🎯 Pipeline Enhancements (Recommended)

### 1. Add Code Coverage

Update `ci.yml`:

```yaml
- name: Install dependencies
  run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    pip install coverage  # Add this

- name: Run tests with coverage
  run: |
    coverage run --source='.' manage.py test
    coverage report
    coverage html

- name: Upload coverage reports
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage.xml
```

### 2. Add Linting

```yaml
- name: Lint with flake8
  run: |
    pip install flake8
    flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
```

### 3. Add Security Scanning

```yaml
- name: Security check with bandit
  run: |
    pip install bandit
    bandit -r . -f json -o bandit-report.json
```

### 4. Add Docker Build Test

```yaml
- name: Test Docker build
  run: |
    docker build -t django-app:test .
    docker run --rm django-app:test python manage.py check
```

### 5. Add Multiple Python Versions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']
    steps:
    - uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
```

---

## 📈 Advanced CI/CD Features

### Continuous Deployment (CD)

Add deployment step after tests pass:

```yaml
jobs:
  test:
    # ... existing test job

  deploy:
    runs-on: ubuntu-latest
    needs: test  # Only run after tests pass
    if: github.ref == 'refs/heads/main'
    steps:
    - name: Deploy to AWS
      run: |
        # Add deployment commands here
        echo "Deploying to production..."
```

### Environment-Specific Testing

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    env:
      DJANGO_SETTINGS_MODULE: mysite.settings
      DATABASE_URL: sqlite:///test_db.sqlite3
```

### Caching Dependencies

```yaml
- name: Cache pip dependencies
  uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

---

## ✅ Pre-Push Checklist

Before pushing to trigger CI/CD:

- [ ] Run tests locally: `python manage.py test`
- [ ] Run Django check: `python manage.py check`
- [ ] Verify requirements.txt is updated
- [ ] Check .gitignore excludes sensitive files
- [ ] Review changes: `git diff`
- [ ] Write meaningful commit message
- [ ] Ensure on correct branch

---

## 📊 Pipeline Status Badge

Add to your README.md:

```markdown
![CI Pipeline](https://github.com/Bamideleflint/Django-App/actions/workflows/ci.yml/badge.svg)
```

Replace `Bamideleflint/Django-App` with your actual repository path.

---

## 🔐 GitHub Secrets (For Future Use)

When you add deployment or external services:

1. Go to GitHub Repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add secrets like:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DOCKER_USERNAME`
   - `DOCKER_PASSWORD`
   - `SECRET_KEY`

Use in workflow:

```yaml
- name: Deploy
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  run: |
    # Deployment commands
```

---

## 📚 Useful Commands

### View Git Status
```bash
git status
```

### Check Current Branch
```bash
git branch
```

### View Recent Commits
```bash
git log --oneline -5
```

### Create and Push Branch
```bash
git checkout -b feature-name
git push -u origin feature-name
```

### Force Re-run CI
```bash
git commit --allow-empty -m "chore: Trigger CI pipeline"
git push
```

---

## 🎓 Best Practices

1. ✅ **Write tests first** - Test-driven development
2. ✅ **Run locally** - Always test before pushing
3. ✅ **Small commits** - Easier to debug failures
4. ✅ **Meaningful messages** - Clear commit descriptions
5. ✅ **Monitor pipeline** - Check GitHub Actions tab
6. ✅ **Fix immediately** - Don't ignore failing tests
7. ✅ **Keep updated** - Update dependencies regularly
8. ✅ **Security first** - Never commit secrets

---

## 🔗 Resources

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Django Testing:** https://docs.djangoproject.com/en/5.2/topics/testing/
- **Python unittest:** https://docs.python.org/3/library/unittest.html
- **Coverage.py:** https://coverage.readthedocs.io/

---

## 📝 Next Steps

1. **Test the pipeline now:**
   ```bash
   cd /home/bamideleflint/Django-App/Django_Project
   git add .
   git commit -m "feat: Add test suite and CI/CD documentation"
   git push origin main
   ```

2. **Watch it run:** Go to GitHub → Actions tab

3. **Add coverage:** Implement code coverage reporting

4. **Enhance security:** Add bandit security scanning

5. **Deploy automatically:** Add CD pipeline for AWS

---

**Pipeline Status:** ✅ Ready to Test  
**Test Count:** 10 tests  
**Coverage Target:** 80%+  
**Last Updated:** 2025-10-21
