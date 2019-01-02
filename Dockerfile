FROM wordpress:cli

ENV WP_PORT=1234
ENV WP_URL="localhost:$WP_PORT" \
  WP_USER=admin \
  WP_PASSWORD=password \
  WP_EMAIL=not@real.com \
  WP_TITLE=WordPress \
  WP_DESCRIPTION="Just another WordPress Site" \
  WP_DEBUG=true \
  WP_THEME=twentynineteen

COPY docker-install.sh /usr/local/bin/

USER root

RUN chmod 755 /usr/local/bin/docker-install.sh

RUN mv /usr/local/bin/wp /usr/local/bin/_wp && \
  echo -e '#!/bin/sh\n_wp --allow-root "$@"' > /usr/local/bin/wp && \
  chmod +x /usr/local/bin/wp

CMD [ "docker-install.sh" ]