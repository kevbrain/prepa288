FROM registry.access.redhat.com/ubi8/ubi:8.0 

MAINTAINER Red Hat Training <training@redhat.com>

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html 

RUN   yum install -y --no-docs --disableplugin=subscription-manager httpd && \ 
      yum clean all --disableplugin=subscription-manager -y && \
      echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

# Allows child images to inject their own content into DocumentRoot
ONBUILD COPY src/ ${DOCROOT}/ 

EXPOSE 8080
LABEL io.openshift.expose-services="8080:http"

# This stuff is needed to ensure a clean start
RUN chgrp -R 0 /var/www/html /var/run/httpd /var/log/httpd && \
    chmod -R g=u /var/www/html /var/run/httpd /var/log/httpd

RUN rm -rf /run/httpd && mkdir /run/httpd

# Run as the root user
USER 1001 

# Launch httpd
CMD /usr/sbin/httpd -DFOREGROUND
