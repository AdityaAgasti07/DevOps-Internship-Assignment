# Multi-stage Dockerfile for FastAPI application

# Stage 1: Build stage
FROM python:3.13-slim as builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Stage 2: Runtime stage
FROM python:3.13-slim as runtime

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Python environment from builder stage
COPY --from=builder /app/.venv /app/.venv

# Copy application code
COPY server.py ./

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Expose port 8000 (default FastAPI port)
EXPOSE 8000

# Run the FastAPI application
CMD ["python", "-m", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"] 