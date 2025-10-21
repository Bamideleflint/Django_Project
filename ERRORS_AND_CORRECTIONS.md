# Errors and Corrections

## Issues Found in Current Implementation

### 1. **CRITICAL: Hardcoded Secret Key in settings.py**
**Location**: `mysite/settings.py` line 23

**Error**:
```python
SECRET_KEY = 'django-insecure-g+54*uw%k_y0gbb756dne_o(7@q=eip6+&kz^gfs#lpya+%p#_'
```

**Issue**: Secret key is exposed in source code, which is a security vulnerability.

**Correction**:
```python
from decouple import config

SECRET_KEY = config('SECRET_KEY', default='django-insecure-PLACEHOLDER')
```

Create `.env` file:
```
SECRET_KEY=your-secret-key-here
```

---

### 2. **Typo in settings.py Comment**
**Location**: `mysite/settings.py` line 40

**Error**:
```python
'core',  # ← ADD THIS LINEq
```

**Issue**: Extra "q" at the end of the comment.

**Correction**:
```python
'core',  # ← ADD THIS LINE
```

---

### 3. **Missing ALLOWED_HOSTS Configuration**
**Location**: `mysite/settings.py` line 28

**Error**:
```python
ALLOWED_HOSTS = []
```

**Issue**: Empty ALLOWED_HOSTS will prevent the app from running on deployed servers.

**Correction**:
```python
from decouple import config

ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='localhost,127.0.0.1').split(',')
```

In `.env`:
```
ALLOWED_HOSTS=localhost,127.0.0.1,your-ec2-ip-here.com
```

---

### 4. **DEBUG Mode Hardcoded**
**Location**: `mysite/settings.py` line 26

**Error**:
```python
DEBUG = True
```

**Issue**: DEBUG should never be True in production.

**Correction**:
```python
from decouple import config

DEBUG = config('DEBUG', default=False, cast=bool)
```

---

### 5. **Missing Tests**
**Location**: `core/tests.py`

**Error**: Only placeholder comment, no actual tests.

**Issue**: CI pipeline runs `python manage.py test` but there are no tests to validate functionality.

**Correction**:
```python
from django.test import TestCase, Client
from django.urls import reverse

class HomeViewTests(TestCase):
    def setUp(self):
        self.client = Client()
    
    def test_home_page_status_code(self):
        response = self.client.get(reverse('home'))
        self.assertEqual(response.status_code, 200)
    
    def test_home_page_template(self):
        response = self.client.get(reverse('home'))
        self.assertTemplateUsed(response, 'home.html')
    
    def test_home_page_contains_message(self):
        response = self.client.get(reverse('home'))
        self.assertContains(response, 'Hello from Django CI/CD!')
```

---

### 6. **Docker Compose Version Deprecated**
**Location**: `docker-compose.yml` line 2

**Error**:
```yaml
version: '3.8'
```

**Issue**: Version key is deprecated in Docker Compose v2+.

**Correction**: Remove the version line entirely:
```yaml
services:
  web:
    build: .
    # ... rest of config
```

---

### 7. **Terraform EC2 Instance Has No SSH Access**
**Location**: `terraform/main.tf`

**Error**: No key_name specified for EC2 instance and commented out remote-exec provisioner.

**Issue**: Cannot SSH into the instance to deploy or debug.

**Correction**: Add key_name parameter:
```hcl
resource "aws_instance" "django_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name  # Add this
  vpc_security_group_ids = [aws_security_group.django_sg.id]
  # ... rest of config
}
```

Add to `variables.tf`:
```hcl
variable "key_pair_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
  default     = "my-django-key"
}
```

Add SSH rule to security group:
```hcl
ingress {
  description = "SSH"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["your-ip-address/32"]  # Restrict to your IP
}
```

---

### 8. **Missing STATIC_ROOT for Production**
**Location**: `mysite/settings.py`

**Error**: Only STATIC_URL is defined.

**Issue**: Cannot collect static files for production deployment.

**Correction**:
```python
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'  # Add this
```

---

### 9. **No CSRF Trusted Origins for Docker**
**Location**: `mysite/settings.py`

**Error**: Missing CSRF_TRUSTED_ORIGINS.

**Issue**: CSRF validation may fail when accessing from different hosts.

**Correction**:
```python
CSRF_TRUSTED_ORIGINS = config(
    'CSRF_TRUSTED_ORIGINS',
    default='http://localhost:8000,http://127.0.0.1:8000'
).split(',')
```

---

### 10. **Minimal README**
**Location**: `README.md`

**Error**: Only contains project title.

**Issue**: No documentation for setup, deployment, or usage.

**Correction**: See PROJECT_DOCUMENTATION.md for comprehensive content to add.

---

### 11. **Terraform .gitignore Missing**
**Location**: Root `.gitignore`

**Error**: Terraform state files are not ignored.

**Issue**: Sensitive state data could be committed.

**Correction**: Add to `.gitignore`:
```
# Terraform
terraform/.terraform/
terraform/*.tfstate
terraform/*.tfstate.backup
terraform/.terraform.lock.hcl
```

---

### 12. **No Requirements for Production Server**
**Location**: `requirements.txt`

**Error**: Missing production-grade WSGI server.

**Issue**: Django's development server shouldn't be used in production.

**Correction**: Add to requirements.txt:
```
gunicorn==22.0.0
```

Update Dockerfile CMD:
```dockerfile
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mysite.wsgi:application"]
```

---

## Summary of Critical Fixes Needed

**Priority 1 (Security)**:
1. Move SECRET_KEY to environment variable
2. Configure DEBUG from environment
3. Set proper ALLOWED_HOSTS
4. Add .terraform to .gitignore

**Priority 2 (Functionality)**:
5. Add SSH access to EC2 instance
6. Write actual tests for CI pipeline
7. Add gunicorn for production
8. Configure STATIC_ROOT

**Priority 3 (Code Quality)**:
9. Fix typo in settings.py comment
10. Remove deprecated docker-compose version
11. Add CSRF_TRUSTED_ORIGINS
12. Improve README documentation
