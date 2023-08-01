# Stage 1: Build the application
FROM python:3.11.4-alpine3.17 AS builder

# Make virtual environment
RUN python -m venv /opt/venv

# Set PATH to virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install --upgrade pip & \
    pip3 install --no-cache-dir -r requirements.txt

# Stage 2: Create the final image running application
FROM python:3.11.4-alpine3.17 AS run

# Set the working directory in the container
WORKDIR /app

ENV PATH="/opt/venv/bin:$PATH" \
    # Keeps Python from generating .pyc files in the container
    PYTHONDONTWRITEBYTECODE=1 \
    # Turns off buffering for easier container logging
    PYTHONBUFFERED=1

# Copy installed dependencies from build stage
COPY --from=builder /opt/venv /opt/venv

# Copy the application code to the container
ADD src/ .

# Listen for traffic on port 8000 (changed from 8080)
EXPOSE 8080

# Set the command to run your application with Gunicorn using the virtual environment
CMD ["/opt/venv/bin/gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
