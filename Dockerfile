# Use official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install Robot Framework and dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create test results directory
RUN mkdir -p test-results

# Default command - run all tests
CMD ["robot", "--outputdir", "test-results", "tests/"]
