# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install application dependencies
RUN pip install --no-cache-dir flask pytz

# Expose port 8080 for the Flask web server
EXPOSE 8080

# Command to run the application
CMD ["python", "app.py"]