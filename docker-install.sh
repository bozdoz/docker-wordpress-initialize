#!/bin/sh
set -euo pipefail

if [[ -f wp-config.php && -f .cli-initialized ]]; then
    exit 0
fi

if [ ! -f wp-config.php ]; then
    echo "WordPress not found in $PWD!"
    ( set -x; sleep 15 )
fi

if [ ! -f .cli-initialized ]; then
    echo "Initializing WordPress install!"

    echo $WP_URL
    echo $WP_USER
    echo $WP_EMAIL

    wp core install \
        --url="$WP_URL" \
        --admin_user=$WP_USER \
        --admin_password=$WP_PASSWORD \
        --admin_email=$WP_EMAIL \
        --title="$WP_TITLE" \
        --skip-email \
        --skip-plugins
        
    wp core update

    wp option update blogdescription "$WP_DESCRIPTION"
    
    wp config set WP_DEBUG $WP_DEBUG --raw
    
    wp theme activate $WP_THEME

    wp rewrite structure '/%postname%/'

    touch .cli-initialized
fi
