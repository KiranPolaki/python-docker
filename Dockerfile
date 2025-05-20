FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run tests (optional)
# RUN python -m pytest

# Expose port if your app needs it
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
