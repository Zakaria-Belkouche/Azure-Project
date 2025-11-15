# Provides Django's built-in testing tools (extends Python's unittest)
from django.test import TestCase
# reverse() allows to look up URLs by their name instead of hardcoding paths
from django.urls import reverse

# Test suite for the SpellChecker API endpoints
class SpellCheckerApiTests(TestCase):
    def test_health(self):
         # Get the URL for the 'health' endpoint (defined in urls.py)
        url = reverse("health")
         # Make a GET request to the endpoint
        resp = self.client.get(url)
        # Ensure the request returns HTTP 200 OK
        self.assertEqual(resp.status_code, 200)
         # Ensure the JSON response is exactly {"status": "ok"}
        self.assertEqual(resp.json(), {"status": "ok"})
        
    # Test the /api/spellcheck/ endpoint (POST)
    def test_spellcheck(self):
        # Get the URL for the 'spellcheck' endpoint (defined in urls.py)
        url = reverse("spellcheck")
        # Input payload that simulates user input
        payload = {"text": "This are bad sentence."}
         # Make a POST request with JSON content
        resp = self.client.post(url, payload, content_type="application/json")
        # API must respond with HTTP 200 OK for valid input
        self.assertEqual(resp.status_code, 200)
        # Parse JSON response body
        data = resp.json()
        # Verify the API returns the original text back
        self.assertEqual(data["original_text"], payload["text"])
        # Check that the response contains a corrected_text field
        self.assertIn("corrected_text", data)
        # The corrected text should be different from the original,
        # meaning that the correction logic is actually doing something
        self.assertNotEqual(data["corrected_text"], payload["text"])
