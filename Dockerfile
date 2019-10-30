FROM ubuntu:18.04
LABEL maintainer="cal.loomis@gmail.com"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx -qq && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists

# deactivate the default page, create a customized one
ADD nginx.conf /etc/nginx/nginx.conf
ADD custom /etc/nginx/sites-available/custom
ADD index.html /var/www/html-custom/index.html
RUN rm /etc/nginx/sites-enabled/default && \
    ln -sf /etc/nginx/sites-available/custom /etc/nginx/sites-enabled/custom

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/usr/sbin/nginx"]

