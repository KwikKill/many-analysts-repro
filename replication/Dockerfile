FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy analysis script
COPY team-0.py ./

# Run the analysis
CMD ["python", "team-0.py"]
