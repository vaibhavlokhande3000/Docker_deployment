# Stage 1: Builder
FROM python:3.9-slim as builder

WORKDIR /app

# Install build dependencies (if needed for some python packages)
RUN apt-get update && apt-get install -y gcc

# Create a virtual environment to install dependencies
RUN python -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.9-slim

WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Enable venv in the final image
ENV PATH="/opt/venv/bin:$PATH"

# Copy application code
COPY . .

# Run the application
CMD ["python", "app.py"]