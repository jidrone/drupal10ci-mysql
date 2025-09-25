# Drupal 10 MySQL 8 Docker Image

This Docker image provides an optimized MySQL 8.0 database server specifically configured for Drupal 10 with low memory consumption and performance tuning.

## Features

- **MySQL 8.0** with Drupal-optimized configuration
- **Low memory footprint** (configured for small containers)
- **Performance optimized** for Drupal's table structure and queries
- **UTF8MB4 support** for full Unicode compatibility
- **Security hardened** with best practices
- **Pre-configured** for Drupal 10 requirements

## Quick Start

### Build the Image

```bash
docker build -t drupal10-mysql .
```

### Run the Container

```bash
docker run -d \
  --name drupal-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=your_root_password \
  -e MYSQL_DATABASE=drupal \
  -e MYSQL_USER=drupal \
  -e MYSQL_PASSWORD=your_drupal_password \
  drupal10-mysql
```

**Important**: Always set passwords via environment variables at runtime, never hardcode them in the image for security reasons.

### Using Docker Compose

```yaml
version: '3.8'
services:
  mysql:
    build: .
    container_name: drupal-mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: drupal
      MYSQL_USER: drupal
      MYSQL_PASSWORD: drupalpassword
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./mysql-logs:/var/log/mysql
    restart: unless-stopped

volumes:
  mysql_data:
```

## Configuration

### Memory Optimization

The image is configured with the following memory-optimized settings:

- **InnoDB Buffer Pool**: 128MB (adjustable based on available memory)
- **Max Connections**: 50 (suitable for small to medium Drupal sites)
- **Temporary Tables**: 32MB limit
- **Performance Schema**: Disabled to save memory

### Drupal-Specific Optimizations

- UTF8MB4 character set for full Unicode support
- Optimized InnoDB settings for Drupal's table structure
- Proper indexing strategy for Drupal queries
- Binary logging configured for development environments

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `MYSQL_ROOT_PASSWORD` | Yes | Root user password (set at runtime) |
| `MYSQL_DATABASE` | No | Default database name (defaults to `drupal`) |
| `MYSQL_USER` | No | Database user (defaults to `drupal`) |
| `MYSQL_PASSWORD` | No | Database user password (set at runtime) |

**Security Note**: Passwords are not included in the image for security reasons. You must provide them at runtime via environment variables.

## Performance Tuning

### For Production

For production environments, consider adjusting these settings in `mysql-drupal.conf`:

```ini
# Increase buffer pool size based on available memory
innodb_buffer_pool_size = 512M  # or higher

# Enable performance schema for monitoring
performance_schema = ON

# Adjust connection limits
max_connections = 100
```

### Memory Requirements

- **Minimum**: 256MB RAM
- **Recommended**: 512MB+ RAM
- **Production**: 1GB+ RAM

## Security Features

- Disabled local file loading
- Symbolic links disabled
- Name resolution skipped for faster connections
- Unused storage engines disabled
- Proper user permissions for Drupal

## Monitoring

The container includes:

- Slow query logging (queries > 2 seconds)
- Error logging
- Binary logging for point-in-time recovery

Logs are available in `/var/log/mysql/` inside the container.

## Troubleshooting

### Connection Issues

If you can't connect to MySQL:

1. Check if the container is running: `docker ps`
2. Verify port mapping: `docker port drupal-mysql`
3. Check logs: `docker logs drupal-mysql`

### Performance Issues

1. Monitor slow query log: `docker exec drupal-mysql tail -f /var/log/mysql/slow.log`
2. Check error log: `docker exec drupal-mysql tail -f /var/log/mysql/error.log`
3. Adjust memory settings in `mysql-drupal.conf` if needed.

## License

This Docker image is based on the official MySQL Docker image and follows the same licensing terms.
