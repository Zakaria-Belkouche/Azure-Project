# Spell Checker App, Full Stack Deployment with Terraform, Docker & Azure

- A full-stack Spell Checker application built with React (frontend) and Django (backend), fully deployed on Microsoft Azure using Terraform, Docker, and monitored with Prometheus & Grafana. CI/CD automation is handled through GitHub Actions.

 ## Features Overview
 
### Frontend (React)

- User text input and API calls with fetch()
- React Hooks (useState) for managing state
- Displays corrected text, loading, and error messages

### Backend (Django)

- REST API endpoints (/api/health)
- Processes text and returns corrected output as JSON
- Includes Django unit tests
