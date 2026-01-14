FROM python:3.11-slim

WORKDIR /app

# Install kubernetes client
RUN pip install --no-cache-dir kubernetes==29.0.0

# Copy scheduler code
COPY scheduler.py .

# Run the scheduler
CMD ["python", "scheduler.py"]
