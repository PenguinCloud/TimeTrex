FROM code-dal1.penguintech.group:5050/ptg/standards/docker-ansible-image:stable
LABEL company="Penguin Tech Group LLC"
LABEL org.opencontainers.image.authors="info@penguintech.group"
LABEL license="GNU AGPL3"

# GET THE FILES WHERE WE NEED THEM!
COPY . /opt/manager/
WORKDIR /opt/manager

# UPDATE as needed
RUN apt update && apt dist-upgrade -y && apt auto-remove -y && apt clean -y

# PUT YER ARGS in here
ARG APP_TITLE="TimeTrex"
ARG APP_LINK="https://www.timetrex.com/direct_download/TimeTrex_Community_Edition-manual-installer.zip"
ARG TIMETREX_VER="TimeTrex_Community_Edition_v16.3.2"

# BUILD IT!
RUN ansible-playbook build.yml -c local

ENV DATABASE_NAME="timetrex"
ENV DATABASE_USER="timetrex"
ENV DATABASE_PASSWORD="p@ssword"
ENV DATABASE_HOST="postgresql"
ENV DATABASE_PORT="5432"
ENV URL="https://localhost:8443"
ENV CSRF="FALSE"
ENV ORGANIZATION_NAME="name"
ENV ORGANIZATION_COUNTRY="US"
ENV ORGANIZATION_EMAIL="admin@localhost"
ENV SERVER_ADDRESS="localhost"
ENV SSL_CERT="open"
ENV PROTOCOL="https"
ENV HTTP_PORT="8080"
ENV HTTPS_PORT="8443"
ENV FILE_LIMIT="1042"

# Switch to non-root user
USER ptg-user

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Entrypoint time (aka runtime)
ENTRYPOINT ["/bin/bash","/opt/manager/entrypoint.sh"]