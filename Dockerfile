# Use the official Ruby image from the Docker Hub
FROM ruby:3.2.3

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock /app/

# Install the required gems
RUN bundle install

# Copy the current directory contents into the container at /app
COPY . /app

EXPOSE 4567

# Run the ruby script when the container launches
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]