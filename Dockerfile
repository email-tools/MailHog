#
# MailHog Dockerfile
#

FROM golang:1.11-alpine3.9

# Install ca-certificates, required for the "release message" feature:
RUN apk --no-cache add \
    ca-certificates

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies \
    git \
  && go get github.com/email-tools/MailHog \
  && apk del --purge build-dependencies


FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /home/mailhog

COPY --from=0 /go/bin/MailHog /usr/local/bin/MailHog

# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

USER mailhog

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025
