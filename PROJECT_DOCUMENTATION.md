# Django CI/CD Project - Documentation

## Project Overview
A Django web application with CI/CD pipeline, Docker containerization, and AWS infrastructure provisioning using Terraform.

## Tech Stack
- **Framework**: Django 5.2.7
- **Python Version**: 3.12
- **Database**: SQLite (development)
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions
- **Infrastructure**: Terraform (AWS)
- **Environment Management**: python-decouple

## Project Structure
```
Django_Project/
├── .github/workflows/
│   └── ci.yml                 # GitHub Actions CI pipeline
├── core/                      # Main Django app
│   ├── templates/
│   │   └── home.html         # Bootstrap-styled homepage
│   ├── views.py              # Home view
│   ├── urls.py               # App URL routing
│   └── tests.py              # Tests (placeholder)
├── mysite/                    # Django project settings
│   ├── settings.py           # Configuration
│   ├── urls.py               # Main URL routing
│   ├── wsgi.py              # WSGI entry point
│   └── asgi.py              # ASGI entry point
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # AWS resources (EC2, Security Group)
│   ├── variables.tf          # Terraform variables
│   └── outputs.tf            # Terraform outputs
├── env/                       # Virtual environment
├── Dockerfile                 # Container image definition
├── docker-compose.yml         # Multi-container orchestration
├── requirements.txt           # Python dependencies
├── .gitignore                # Git ignore rules
└── manage.py                 # Django CLI tool
```

## Implemented Features

### 1. Django Application
- **Core App**: Simple web app with homepage
- **Template**: Bootstrap 5 integrated homepage
- **URL Routing**: Configured both project and app-level URLs
- **Settings**: Core app registered in INSTALLED_APPS
- **Static Files**: Using Bootstrap CDN

### 2. Docker Configuration
**Dockerfile Features:**
- Base image: Python 3.12 slim
- Environment variables for Python optimization
- Working directory: `/app`
- Port exposure: 8000
- Auto-starts development server on container launch

**Docker Compose:**
- Service name: `web`
- Port mapping: 8000:8000
- Volume mounting for live code reload
- DEBUG environment variable

### 3. CI/CD Pipeline (GitHub Actions)
**Triggers:**
- Push to `main` branch
- Pull requests to `main` branch

**Pipeline Steps:**
1. Checkout code
2. Set up Python 3.12
3. Install dependencies
4. Run Django tests
5. Check for syntax errors (`python manage.py check`)

### 4. Infrastructure as Code (Terraform)
**AWS Resources:**
- **Security Group**: Allows inbound traffic on port 8000
- **EC2 Instance**: 
  - Ubuntu 22.04 LTS AMI
  - t2.micro instance type
  - Automated Docker installation via user_data
  - Tagged as "django-ci-cd-server"

**Terraform Files:**
- `main.tf`: Provider config (us-east-1), security group, EC2 instance
- `variables.tf`: Configurable region, AMI, instance type
- `outputs.tf`: Outputs EC2 public IP
- Uses AWS profile: "terraform-deployer"

### 5. Dependencies
- **asgiref**: 3.10.0 (ASGI support)
- **Django**: 5.2.7 (latest)
- **python-decouple**: 3.8 (environment variable management)
- **sqlparse**: 0.5.3 (SQL parsing)

### 6. Version Control
- Git initialized
- .gitignore configured for:
  - Virtual environment (`env/`)
  - Python cache (`__pycache__/`, `*.pyc`)
  - Database (`db.sqlite3`)
  - Environment files (`.env`)
  - macOS files (`.DS_Store`)

## Current Application Flow
1. User visits homepage (localhost:8000 or EC2 public IP)
2. Django routes to `core.views.home`
3. View renders `home.html` template with context message
4. Template displays Bootstrap-styled welcome page

## Deployment Methods Available

### Local Development
```bash
python manage.py runserver
```

### Docker
```bash
docker-compose up
```

### AWS (Terraform)
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Configuration Notes
- SECRET_KEY is hardcoded (development only - needs environment variable)
- DEBUG=True (development mode)
- ALLOWED_HOSTS is empty (needs configuration for production)
- Using SQLite database (suitable for development)
- No SSH key configured for EC2 instance
