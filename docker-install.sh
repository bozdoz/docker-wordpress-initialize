#!/bin/sh
set -euo pipefail

if [ ! -f wp-config.php ]; then
    echo "WordPress not found in $PWD!"
    ( set -x; sleep 15 )
fi

if ! $(wp core is-installed); then
    echo "Initializing WordPress install!"

    wp core install \
        --url="$WP_URL" \
        --admin_user=$WP_USER \
        --admin_password=$WP_PASSWORD \
        --admin_email=$WP_EMAIL \
        --title="$WP_TITLE" \
        --skip-email \
        --skip-plugins
        
    wp core update
    
    wp core update-db

    wp option update blogdescription "$WP_DESCRIPTION"
    
    wp config set WP_DEBUG $WP_DEBUG --raw
    
    wp theme install $WP_THEME --activate
    
    wp rewrite structure '/%postname%/'
    
    wp plugin delete akismet hello
    
    if [ ! -z "$WP_PLUGINS" ]; then
        wp plugin install $WP_PLUGINS --activate
    fi
    
    # custom initial posts/pages script
    if [ -f /app/docker-posts.sh ]; then
        sh /app/docker-posts.sh
    fi

    # make everything owned by www-data
    chown -R xfs:xfs .
fi
