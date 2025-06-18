# Dockerfile for FastAPI application

FROM python:3.13-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml ./

# Install dependencies using pip
RUN pip install --no-cache-dir fastapi[standard] uvicorn

# Copy application code
COPY server.py ./

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Expose port 8000 (default FastAPI port)
EXPOSE 8000

# Run the FastAPI application
CMD ["python", "-m", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"] 