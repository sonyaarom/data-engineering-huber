FROM python:3.11-slim-bullseye

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# If you need spaCy models
RUN python -m spacy download en_core_web_sm

# Copy the rest of the application
COPY . .

# Set environment variables
ENV PYTHONPATH="${PYTHONPATH}:/app"
ENV PORT=1234

# Expose the port the app runs on
EXPOSE 1234

# Command to run the application
CMD ["python", "run_ui.py"]