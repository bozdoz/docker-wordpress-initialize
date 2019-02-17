# docker-wordpress-initialize

Initialize WordPress site in Docker with WP-CLI and an install script

### Usage

#### docker-compose.yml

```
version: '3.3'

services:
  db:
    image: mariadb
    volumes:
      - db_volume:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-whocares}

  cli:
    image: bozdoz/wordpress-initialize
    env_file: .env
    depends_on:
      - db
    volumes: 
      - wp_volume:/var/www/html

  wordpress:
    image: wordpress
    depends_on:
      - cli
    volumes:
      - wp_volume:/var/www/html
    ports:
      - ${WP_PORT:-1234}:80
    restart: always
    environment:
      WORDPRESS_DB_PASSWORD: ${MYSQL_ROOT_PASSWORD:-whocares}
      WORDPRESS_DB_HOST: db:3306
  
volumes:
  db_volume:
  wp_volume:
```

#### .env

```
WP_PORT=1234
WP_URL=localhost:1234
WP_USER=admin
WP_PASSWORD=password
WP_EMAIL=not@real.com
WP_TITLE=WordPress
WP_DESCRIPTION=Just Another WordPress Blog
WP_DEBUG=true
WP_THEME=twentynineteen
```

## But Why

This will auto-install WordPress, so you can `docker-compose down -v` and `docker-compose up` without having to re-install WordPress each time.

You can also use this image to run [WP CLI commands](https://wp-cli.org/), like so: `docker-compose run cli wp plugin list` or `docker-compose run cli wp post create --post_type=post --post_title='New Post' --post_content='Another post' --post_status=publish`
