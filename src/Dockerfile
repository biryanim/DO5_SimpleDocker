FROM importing_nginx:latest
WORKDIR /home/

RUN apt-get update \
    && apt-get install -y libfcgi-dev gcc spawn-fcgi \
    && rm -rf /var/lib/apt/lists 

COPY ./hello_world.c .
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./hello_world.sh .

RUN chown -R nginx:nginx /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /home \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid \
    && chmod u-s /usr/bin/gpasswd \
    && chmod u-s /usr/bin/newgrp \
    && chmod u-s /bin/su \
    && chmod u-s /bin/mount \
    && chmod u-s /bin/umount \
    && chmod u-s /usr/bin/chsh \
    && chmod u-s /usr/bin/chfn \
    && chmod u-s /usr/bin/chsh \
    && chmod g-s /usr/bin/expiry \
    && chmod g-s /usr/bin/wall \
    && chmod g-s /sbin/unix_chkpwd \
    && chmod g-s /usr/bin/chage \
    && chmod u-s /usr/bin/passwd

USER nginx

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["../docker-entrypoint.sh"]
CMD ["sh", "./hello_world.sh"]

