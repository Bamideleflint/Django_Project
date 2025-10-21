from django.test import TestCase, Client
from django.urls import reverse


class HomeViewTests(TestCase):
    """Test cases for the home view."""

    def setUp(self):
        """Set up test client."""
        self.client = Client()
        self.home_url = reverse('home')

    def test_home_page_status_code(self):
        """Test that home page returns 200 status code."""
        response = self.client.get(self.home_url)
        self.assertEqual(response.status_code, 200)

    def test_home_page_uses_correct_template(self):
        """Test that home page uses the correct template."""
        response = self.client.get(self.home_url)
        self.assertTemplateUsed(response, 'home.html')

    def test_home_page_contains_welcome_message(self):
        """Test that home page contains the expected message."""
        response = self.client.get(self.home_url)
        self.assertContains(response, 'Hello from Django CI/CD!')

    def test_home_page_contains_bootstrap(self):
        """Test that home page includes Bootstrap CSS."""
        response = self.client.get(self.home_url)
        self.assertContains(response, 'bootstrap')

    def test_home_page_title(self):
        """Test that home page has correct title."""
        response = self.client.get(self.home_url)
        self.assertContains(response, '<title>Django CI/CD</title>')

    def test_home_page_has_navbar(self):
        """Test that home page has navigation bar."""
        response = self.client.get(self.home_url)
        self.assertContains(response, 'navbar')


class URLTests(TestCase):
    """Test cases for URL routing."""

    def test_home_url_resolves(self):
        """Test that the home URL resolves correctly."""
        url = reverse('home')
        self.assertEqual(url, '/')

    def test_admin_url_accessible(self):
        """Test that admin URL is accessible."""
        response = self.client.get('/admin/login/')
        self.assertEqual(response.status_code, 200)
