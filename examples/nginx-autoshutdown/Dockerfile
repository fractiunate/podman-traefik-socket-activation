FROM nginx:alpine

# Install necessary tools: bash and coreutils for stat
RUN apk add --no-cache bash coreutils

# Copy wrapper script into the container
COPY nginx-wrapper.sh /usr/local/bin/nginx-wrapper.sh
RUN chmod +x /usr/local/bin/nginx-wrapper.sh

# Optional: Replace default Nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Ensure the access log exists
RUN touch /var/log/nginx/access1.log

# Use wrapper as entrypoint
ENTRYPOINT ["/usr/local/bin/nginx-wrapper.sh"]