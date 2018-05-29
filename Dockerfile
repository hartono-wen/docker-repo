# Created by:       Hartono <hartono.wen@gmail.com>
# Last updated by:  Hartono <hartono.wen@gmail.com>
# Last updated at:  Monday, 2018-05-16 19:58 PM GMT+7
# Description:		This Dockerfile will install:
#					1. 	Postgresql 10.4
#					2. 	Golang 1.10.2
#					3. 	OpenJDK 8
#					4. 	Gradle 4.7
#					5. 	PHP 7.2.5
#					6. 	NodeJS 8.11.2
#					7. 	NPM 5.6.0
#					8. 	.NET Core 2.1.200
#					9. 	Nginx 1.13.12
#					10. Python 3.6.5
#					11. Angular CLI 6.0.1
#					12. Composer 1.6.5
#					13. Jenkins 2.107.3
#					14. SDKMan 5.6.3
#         15. Maven 3.5.3
#         16. Scala 2.12.6
#         17. Kotlin 1.2.41
#         18. Grails 3.3.5
#         19. Spring CLI 2.0.2
#         20. Electron 2.0.2
#         21. Perl 5.22.1

# Use base image Ubuntu:16.04 LTS
FROM ubuntu:16.04

LABEL maintainer="Hartono <hartono.wen@gmail.com>"

ARG DOTNET_CORE_PKG=packages-microsoft-prod.deb
ARG GOLANG_PKG=go1.10.2.linux-amd64.tar.gz
ARG POSTGRES_ASC=ACCC4CF8.asc
ARG NGINX_KEY=nginx_signing.key
ARG JENKINS_KEY=jenkins-ci.org.key

ARG NODEJS_SRC=https://deb.nodesource.com/setup_8.x
ARG DOTNETCORE_SRC=https://packages.microsoft.com/config/ubuntu/16.04/$DOTNET_CORE_PKG
ARG GOLANG_SRC=https://dl.google.com/go/$GOLANG_PKG
ARG POSTGRES_SRC=https://www.postgresql.org/media/keys/$POSTGRES_ASC
ARG NGINX_SRC=https://nginx.org/keys/$NGINX_KEY
ARG JENKINS_SRC=https://pkg.jenkins.io/debian/$JENKINS_KEY

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:/usr/local/go/bin

# Run apt-get update and install all prerequisites libraries for later installation purposes
RUN apt-get update &&  \
apt-get -y upgrade &&  \
apt-get install -y curl apt-transport-https apt-utils build-essential ca-certificates libpq-dev libssl-dev git zip && \
apt-get install -y openssl nano libffi-dev zlib1g-dev python-software-properties software-properties-common unzip && \
apt-get install -y libgtk-3-dev libxss1 libgconf-2-4 sqlite3 && \
echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
LC_ALL=C.UTF-8 add-apt-repository -y -u ppa:ondrej/php && add-apt-repository -y ppa:jonathonf/python-3.6

# Use curl to download the needed installation package
RUN curl -s -L ${NODEJS_SRC} | bash - && \
curl -s -O ${DOTNETCORE_SRC} && dpkg -i $DOTNET_CORE_PKG && \
curl -s -O ${GOLANG_SRC} && tar -C /usr/local -xzf ${GOLANG_PKG} && \
curl -s -O ${POSTGRES_SRC} && apt-key add ${POSTGRES_ASC} && \
curl -s -O ${NGINX_SRC} && apt-key add ${NGINX_KEY} && \
echo 'deb https://nginx.org/packages/mainline/ubuntu/ xenial nginx' >> /etc/apt/sources.list && \
echo 'deb-src https://nginx.org/packages/mainline/ubuntu/ xenial nginx' >> /etc/apt/sources.list && \
apt-get remove nginx-common && \
curl -s -O ${JENKINS_SRC} && apt-key add ${JENKINS_KEY} && \
echo 'deb https://pkg.jenkins.io/debian-stable binary/' >> /etc/apt/sources.list && \
curl -s "https://get.sdkman.io" | bash && /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh"

# Update repository and install the necessary packages
RUN apt-get update && \
apt-get install -y nodejs dotnet-sdk-2.1.200 python3.6 python3-pip postgresql-10 nginx perl openjdk-8-jre jenkins && \
apt-get install -y php7.2 php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml && \
curl -s -S https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set npm config user as root to avoid problems when installing @angular-cli
# (taken from https://stackoverflow.com/questions/44633419/no-access-permission-error-with-npm-global-install-on-docker-image)
RUN npm --global config set user root && \
npm install --global npm@5.6.0 && \
npm install --global @angular/cli electron

USER postgres
RUN /etc/init.d/postgresql start && psql --command "CREATE USER sa WITH SUPERUSER PASSWORD '123';"

USER root
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf && \
echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf && \
/bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh; sdk install maven; sdk install gradle; sdk install kotlin;" && \
/bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh; sdk install springboot; sdk install grails; sdk install scala"

# Clean all temporary files and installer files.
RUN apt-get clean all && rm ${DOTNET_CORE_PKG} ${GOLANG_PKG} ${POSTGRES_ASC} ${NGINX_KEY} ${JENKINS_KEY}

# Interactive run will result in bash command
CMD /etc/init.d/postgresql start && \
/etc/init.d/nginx start && \
/etc/init.d/jenkins start && \
/bin/bash
