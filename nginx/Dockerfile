# Use the official Nginx image
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom configuration
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy your SSL certificates
COPY certs /etc/nginx/certs

# Expose ports
EXPOSE 80 443
