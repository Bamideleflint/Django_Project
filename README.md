# Django CI/CD Project

![Django](https://img.shields.io/badge/Django-5.2.7-green)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![Docker](https://img.shields.io/badge/Docker-enabled-blue)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-orange)
![Infrastructure](https://img.shields.io/badge/IaC-Terraform-purple)

A modern Django web application featuring automated CI/CD pipeline, Docker containerization, comprehensive test suite, and AWS infrastructure provisioning with Terraform.

## ✨ Features

- ✅ **Django 5.2.7** - Latest stable release
- ✅ **GitHub Actions CI/CD** - Automated testing and validation
- ✅ **Comprehensive Test Suite** - 10 tests covering views, URLs, and templates
- ✅ **Docker Support** - Containerized application with docker-compose
- ✅ **Infrastructure as Code** - Terraform configurations for AWS deployment
- ✅ **Bootstrap 5 UI** - Modern, responsive interface
- ✅ **Security Best Practices** - Updated .gitignore, environment variable support

## 📚 Documentation

This project includes comprehensive documentation:

- **[PROJECT_DOCUMENTATION.md](PROJECT_DOCUMENTATION.md)** - Complete overview of what has been implemented
- **[ERRORS_AND_CORRECTIONS.md](ERRORS_AND_CORRECTIONS.md)** - Known issues and how to fix them
- **[FUTURE_ENHANCEMENTS.md](FUTURE_ENHANCEMENTS.md)** - Recommended improvements and next steps
- **[GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)** - Complete CI/CD pipeline reference

## 🚀 Quick Start

### Prerequisites
- Python 3.12
- Docker & Docker Compose (optional)
- AWS account (for deployment)
- Terraform (for infrastructure)

### Local Development

1. **Clone the repository**
```bash
git clone <repository-url>
cd Django_Project
```

2. **Create virtual environment**
```bash
python -m venv env
source env/bin/activate  # Linux/Mac
# or
env\Scripts\activate  # Windows
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Run migrations**
```bash
python manage.py migrate
```

5. **Start development server**
```bash
python manage.py runserver
```

Visit http://localhost:8000

### Using Docker

```bash
docker-compose up
```

Visit http://localhost:8000

## 🧪 Testing

The project includes a comprehensive test suite with 10 tests:

```bash
# Run all tests
python manage.py test

# Run with verbose output
python manage.py test --verbosity=2

# Run specific test class
python manage.py test core.tests.HomeViewTests
```

**Test Coverage:**
- Home page status codes and responses
- Template rendering validation
- Content verification
- URL routing
- Bootstrap integration

## 🏗️ Infrastructure Deployment

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## 📁 Project Structure

```
Django_Project/
├── .github/workflows/     # CI/CD pipeline configuration
│   └── ci.yml            # GitHub Actions workflow
├── core/                  # Main Django application
│   ├── templates/        # HTML templates
│   ├── tests.py          # Test suite (10 tests)
│   ├── views.py          # View functions
│   └── urls.py           # App URL routing
├── mysite/                # Django project settings
│   ├── settings.py       # Configuration
│   ├── urls.py           # Main URL routing
│   └── wsgi.py           # WSGI application
├── terraform/             # AWS infrastructure as code
│   ├── main.tf           # EC2, security groups
│   ├── variables.tf      # Terraform variables
│   └── outputs.tf        # Output values
├── Dockerfile             # Docker image definition
├── docker-compose.yml     # Multi-container orchestration
├── requirements.txt       # Python dependencies
└── .gitignore            # Git ignore patterns (security enhanced)
```

## 🛠️ Tech Stack

**Backend & Framework:**
- Django 5.2.7
- Python 3.12
- python-decouple (environment variables)

**Database:**
- SQLite (development)
- PostgreSQL (production - recommended)

**DevOps & Infrastructure:**
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Terraform (AWS infrastructure)
- AWS EC2, Security Groups

**Frontend:**
- Bootstrap 5 (CDN)
- Responsive design

**Testing:**
- Django TestCase
- 10 comprehensive tests
- Coverage ready

## 🔄 CI/CD Pipeline

**Automated GitHub Actions workflow triggers on:**
- Push to `main` branch
- Pull requests to `main` branch

**Pipeline steps:**
1. ✅ Checkout code
2. ✅ Set up Python 3.12
3. ✅ Install dependencies
4. ✅ Run 10 tests
5. ✅ Django system check

View pipeline status in the **Actions** tab on GitHub.

## ⚠️ Important Notes

**Before Production Deployment:**
- Review [ERRORS_AND_CORRECTIONS.md](ERRORS_AND_CORRECTIONS.md) for known issues
- Move SECRET_KEY and sensitive data to environment variables
- Configure ALLOWED_HOSTS for your domain
- Set DEBUG=False in production
- Add SSH key to EC2 instance for deployment

**Future Improvements:**
- Check [FUTURE_ENHANCEMENTS.md](FUTURE_ENHANCEMENTS.md) for recommended next steps
- PostgreSQL migration
- User authentication system
- REST API development
- Redis caching layer

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License

## 👤 Author

**Bamideleflint**

## 🙏 Acknowledgments

- Django documentation and community
- GitHub Actions for CI/CD automation
- Bootstrap for responsive UI components