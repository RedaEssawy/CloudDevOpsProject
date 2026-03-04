#  Cloud DevOps CI/CD Pipeline Project

A comprehensive, production-ready Cloud DevOps CI/CD pipeline built for cloud-native application deployment on AWS.

This project simulates a real-world enterprise DevOps environment where infrastructure provisioning, CI, and CD are fully automated using cloud-native tools.

---

# 🛠 Tech Stack

- Infrastructure as Code: Terraform (AWS + S3 Backend + CloudWatch)
- Configuration Management: Ansible (Roles + Dynamic Inventory)
- Containerization: Docker
- Orchestration: Kubernetes (Minikube)
- Continuous Integration: Jenkins (Pipeline as Code + Shared Libraries)
- Continuous Deployment: ArgoCD (GitOps)
- Version Control: GitHub

---

#  Implementation Journey

The project was implemented in the following order:

1. Containerization with Docker  
2. Container Orchestration with Kubernetes  
3. Infrastructure Provisioning using Terraform  
4. Configuration Management using Ansible  
5. Continuous Integration using Jenkins  
6. Continuous Deployment using ArgoCD  

---
#  Architecture Diagram
![Arch Project](assets/screenshots/arch.png)


#  Phase 1 — Containerization with Docker

## Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*  

COPY FinalProject/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY FinalProject/app.py .
COPY FinalProject/static/ ./static/
COPY FinalProject/templates/ ./templates/

RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser && \
    chown -R appuser:appgroup /app

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:5000/ || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

---

## Build Docker Image

```bash
docker build -t redaeid/ivolvefinalproject:v1 .
```

![Build 1](assets/screenshots/build-docker-image-1.png)
![Build 2](assets/screenshots/build-docker-image-2.png)

---

## Test Image Locally

```bash
docker run --name test-locally -d -p 5000:5000 redaeid/ivolvefinalproject:v1
docker logs test-locally
```

![Docker Logs](assets/screenshots/docker-logs.png)
![Local Test](assets/screenshots/test-locally.png)

---

## Push to DockerHub

```bash
docker push redaeid/ivolvefinalproject:v1
```

![Push Docker](assets/screenshots/push-image-into-dockerhub.png)

---

# ☸ Phase 2 — Kubernetes (Minikube)

## Start Minikube

```bash
minikube start
```

![Start Minikube](assets/screenshots/start-minikube.png)

---

## Apply Manifests

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

![K8s Apply](assets/screenshots/k8s-apply.png)

---

## Access Application

```bash
minikube service flask-service -n ivolve
```

![Minikube Service](assets/screenshots/minikube-service.png)
![App Running](assets/screenshots/test-app-using-minikube.png)

---

## Scaling Test

```bash
kubectl scale deployment flask-app --replicas=3 -n ivolve
kubectl get pods -n ivolve
```

![Scaling](assets/screenshots/scale--the-app.png)

---

#  Phase 3 — Terraform (AWS Infrastructure)

## Check Terraform Version

```bash
terraform version
```

![Terraform Version](assets/screenshots/terraform-version.png)

---

## Configure AWS

```bash
aws configure
```

![AWS Configure](assets/screenshots/aws-configure.png)

---

## Initialize Terraform

```bash
terraform init
```

![Terraform Init](assets/screenshots/terraform-init.png)

---

## Plan & Apply

```bash
terraform plan
terraform apply -auto-approve
```

![Terraform Plan](assets/screenshots/terraform-plan.png)
![Terraform Apply](assets/screenshots/terraform-apply.png)

---

## Created AWS Resources

![AWS VPC](assets/screenshots/aws-vpc.png)
![AWS EC2](assets/screenshots/aws-ec2.png)

---

#  Phase 4 — Configuration Management (Ansible)

Configured EC2 as Jenkins Agent using Ansible.

```bash
ansible-playbook -i inventory/aws_ec2.yml playbooks/playbook1 \
--user ubuntu \
--private-key /home/reda/.ssh/ansible-key.pem \
--ssh-extra-args "-o StrictHostKeyChecking=accept-new"
```

![Ansible EC2](assets/screenshots/ansible-playbook-ec2.png)

---

# Phase 5 — Continuous Integration (Jenkins)

## Install Jenkins

```bash
sudo apt install fontconfig openjdk-21-jre
sudo apt install jenkins
```

Start Jenkins:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

![Jenkins Login](assets/screenshots/jenkins-login-page.png)

Create an Agent Using the EC2

![Create Agent](assets/screenshots/jenkins-agent-1.png)
![Create Agent](assets/screenshots/jenkins-agent-2.png)
![Status Agent](assets/screenshots/status-of-agent.png)

Then use This Agent in Jenkinsfile as an Agent


---

## Pipeline Stages

1. Clone Source Code  
2. Build Docker Image  
3. Scan Docker Image  
4. Push Image  
5. Update Kubernetes Manifests  
6. Push to Deployment Repo  

![Jenkins Pipeline](assets/screenshots/jenkins-pipeline.png)

---

#  Phase 6 — Continuous Deployment (ArgoCD)

## Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Forward Port:

```bash
kubectl port-forward svc/argocd-server -n argocd 8089:443
```

Get Initial Password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

![ArgoCD Dashboard](assets/screenshots/argocd.png)

---

#  Author

Reda Essawy  
Cloud & DevOps Engineer  
GitHub: https://github.com/RedaEssawy

---
