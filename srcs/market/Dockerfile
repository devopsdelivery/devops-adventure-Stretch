# Description: Dockerfile for the backend service
FROM python:3.11.4-slim-bullseye

# Container work directory
WORKDIR /app

# Environment variables
## Prevents Python from writing pyc
ENV PYTHONDONTWRITEBYTECODE 1

# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install poetry

# Copy dependency files to install dependencies
COPY pyproject.toml poetry.lock* /app/

# Install only the dependencies
RUN poetry install --no-root --only main

# Copy the current directory contents into the container at /app
COPY . /app

# Expose the port the app runs on
EXPOSE 8000

# Run database migrations before starting the server
CMD ["sh", "-c", \
    "poetry run python manage.py makemigrations && \
    poetry run python manage.py migrate --noinput && \
    poetry run python manage.py collectstatic --noinput && \
    poetry run python manage.py runserver 0.0.0.0:8000" \
]

