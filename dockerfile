FROM python:3.11-slim

# Set a working directory
WORKDIR /app

# Prevent Python from writing .pyc files and enable stdout/stderr logging immediately
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Start the app
CMD ["python", "app.py"]
