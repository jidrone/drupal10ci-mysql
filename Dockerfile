# Use official MySQL 8.0 image as base
FROM mysql:8.0

# Set environment variables for MySQL
# Note: Sensitive passwords should be set at runtime, not in the image
ENV MYSQL_DATABASE=drupal

# Create custom MySQL configuration directory
RUN mkdir -p /etc/mysql/conf.d

# Copy optimized MySQL configuration for Drupal 10 with low memory consumption
COPY mysql-drupal.conf /etc/mysql/conf.d/

# Set proper permissions
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /etc/mysql/conf.d

# Expose MySQL port
EXPOSE 3306

# Use the default MySQL entrypoint with memory optimization flags
CMD ["mysqld", \
     "--performance-schema=OFF", \
     "--innodb-buffer-pool-size=128M", \
     "--max-connections=50", \
     "--table-open-cache=64", \
     "--thread-cache-size=8", \
     "--tmp-table-size=32M", \
     "--max-heap-table-size=32M", \
     "--key-buffer-size=8M", \
     "--sort-buffer-size=2M", \
     "--read-buffer-size=2M", \
     "--read-rnd-buffer-size=8M"]
