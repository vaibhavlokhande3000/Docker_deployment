# Global Base: Shared by both builders and runtimes to ensure OS compatibility
FROM python:3.9-slim as base
WORKDIR /app
# Install GCC for building python dependencies if needed
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*
# Setup virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# --- Builder Stage for Backend ---
FROM base as backend-builder
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Builder Stage for Frontend ---
FROM base as frontend-builder
COPY frontend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Final Backend Image ---
FROM python:3.9-slim as backend
WORKDIR /app
COPY --from=backend-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY backend/ . 
# Explicitly using port 5000 as defined in your app.py
EXPOSE 5000 
CMD ["python", "app.py"]

# --- Final Frontend Image ---
FROM python:3.9-slim as frontend
WORKDIR /app
COPY --from=frontend-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY frontend/ .
# Your app.py runs on 5000, though your compose mentioned 80. 
# We expose 5000 to match the actual flask application.
EXPOSE 5000
CMD ["python", "app.py"]
