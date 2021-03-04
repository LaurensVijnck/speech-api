# Alternative approach
curl -X POST --data-binary @"/Users/lvijnck/Desktop/speech-api/services/api/assets/test.wav" -H "Content-Type: application/octet-stream" "http://0.0.0.0:8080/v2/speech"