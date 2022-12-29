FROM registry1.dso.mil/ironbank/redhat/ubi/ubi8-minimal:8.7

USER 0                                                                                      
RUN microdnf update && \                                                                                                
    microdnf -y install \                                                                                               
    jq \
    rsync \
    openssh-clients

CMD ["/bin/sh"]

HEALTHCHECK NONE
