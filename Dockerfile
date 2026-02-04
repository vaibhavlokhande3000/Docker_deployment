# Global Base
FROM python:3.9-slim as base
WORKDIR /app
# Install GCC for building python dependencies if needed
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*
# Setup virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Builder Stage for Backend
FROM base as backend-builder
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Builder Stage for Frontend
FROM base as frontend-builder
COPY frontend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Final Backend Image
FROM python:3.9-slim as backend
WORKDIR /app
COPY --from=backend-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY backend/ . 

EXPOSE 5000 
CMD ["python", "app.py"]

# Final Frontend Image 
FROM python:3.9-slim as frontend
WORKDIR /app
COPY --from=frontend-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY frontend/ .
 

EXPOSE 5000
CMD ["python", "app.py"]
