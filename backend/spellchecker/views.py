# Import decorator to define API view methods (GET, POST, etc.)
from rest_framework.decorators import api_view
# Standard DRF response object
from rest_framework.response import Response
# HTTP status codes (e.g., 200 OK, 400 Bad Request)
from rest_framework import status
# TextBlob library used for spell correction
from textblob import TextBlob

#  Helper function for spell correction
#  Takes input text and returns a corrected version using TextBlob.
#  TextBlob analyzes words and predicts likely corrected spelling.
def auto_correct(text: str) -> str:
    blob = TextBlob(text) # Convert text into a TextBlob object
    corrected = blob.correct() # Perform spell correction
    return str(corrected) # Return corrected text as a string

# Health check endpoint
# Simple health check endpoint used to verify that the backend API is running.
# Returns: {"status": "ok"}
@api_view(["GET"])
def health(request):
    return Response({"status": "ok"})

# Spell-check API endpoint
# Accepts POST requests containing a JSON body with a 'text' field.
# Performs spell correction using TextBlob and returns the corrected text.
@api_view(["POST"])
def spellcheck(request):
    # Extract 'text' field from JSON request body (returns empty string if missing)
    text = request.data.get("text", "")

    # Validate input text
    if not text.strip():
        return Response(
            {"error": "Text is required."},
            status=status.HTTP_400_BAD_REQUEST,
        )
     # Run spell correction
    corrected_text = auto_correct(text)

    # Return both original and corrected text
    return Response(
        {
            "original_text": text,
            "corrected_text": corrected_text,
        },
        status=status.HTTP_200_OK,
    )

