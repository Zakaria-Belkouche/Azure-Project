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

## Cloud Infrastructure 
### Created using Terraform:
- Azure Resource Group
- Virtual Network + Public/Private Subnets
- Ubuntu Linux VM
- Network Security Group with firewall rules (SSH, HTTP, API, Prometheus, Grafana)

## Dockerised Deployment
### The Azure VM runs all components via Docker:
- React frontend
- Django backend
- Prometheus
- Grafana
- Node Exporter
- Blackbox Exporter
