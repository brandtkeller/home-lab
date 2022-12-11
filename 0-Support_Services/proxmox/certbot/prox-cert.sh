#!/usr/local/bin/bash



docker run -it --rm --name certbot \
            --env-file ~/.certmanager-aws \
            --dns 1.1.1.1 \
            -v "$(pwd)/letsencrypt:/etc/letsencrypt" \
            certbot/dns-route53 certonly --dns-route53 \
            -d "$1" --dns-route53-propagation-seconds 60
