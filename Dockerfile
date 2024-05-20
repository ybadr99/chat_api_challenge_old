# Use Ruby 3.3.0 as the base image
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn default-mysql-client

# Set an environment variable to indicate Rails environment
ENV RAILS_ENV=development

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN gem install bundler -v 2.5.6
RUN bundle install

# Copy the rest of the application code
COPY . /app

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/bin/entrypoint.sh

# Expose port 3000 to the outside world
EXPOSE 3000

# Use the entrypoint script to start the application
ENTRYPOINT ["entrypoint.sh"]
