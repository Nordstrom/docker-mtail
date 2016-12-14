FROM quay.io/nordstrom/baseimage-alpine:3.4
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

ADD build/mtail /bin/mtail

ENTRYPOINT ["/bin/mtail"]
