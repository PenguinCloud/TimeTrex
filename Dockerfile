FROM penguintech/core-ansible
LABEL maintainer="Penguin Tech Group LLC"
COPY . /opt/manager/
ENV DATABASE_NAME="timetrex"
ENV DATABASE_USER="timetrex"
ENV DATABASE_PASSWORD="p@ssword"
ENV DATABASE_HOST="localhost"
ENV DATABASE_PORT="5432"
ENV ORGANIZATION_NAME="name"
ENV ORGANIZATION_COUNTRY="US"
ENV ORGANIZATION_EMAIL="admin@localhost"
ENV ORGANISATION_HOSTNAME="ptg.org"
ENV URL="https://127.0.0.1"
ENV CPU_COUNT="2"
ENV FILE_LIMIT="1042"
ENV SSL_KEY="nokey"
ENV SSL_CERTIFICATE="nocert"
ARG APP_LINK="https://www.timetrex.com/direct_download/TimeTrex_Community_Edition-manual-installer.zip"
ARG TIMETREX_VER="TimeTrex_Community_Edition_v15.2.1"
RUN ansible-playbook /opt/manager/upstart.yml -c local --tags build
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
ENTRYPOINT ["ansible-playbook", "/opt/manager/upstart.yml", "-c", "local", "--tags", "run,exec"]