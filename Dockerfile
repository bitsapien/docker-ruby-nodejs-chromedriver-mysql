FROM ruby:2.5-slim-stretch
MAINTAINER bitsapien <bitsapien@gmail.com>


RUN apt-get update
RUN apt-get --yes install gnupg
RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
  key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
  export GNUPGHOME="$(mktemp -d)"; \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
  rm -rf "$GNUPGHOME"; \
  apt-key list > /dev/null

ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.22-1debian9

RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

# # install mysql client, redis client, nodejs, chromedriver
RUN apt-get update
RUN apt-get install --yes software-properties-common build-essential libssl-dev
RUN apt-get install --yes mysql-community-client libmysqlclient-dev
RUN apt-get install --yes curl wget xvfb unzip imagemagick libmagickwand-dev
RUN curl --silent --location https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes libxss1 libappindicator1 libindicator7
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
#RUN dpkg -i google-chrome*.deb
#RUN apt-get install -f
#RUN apt-get install --yes xvfb unzip fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxtst6 xdg-utils
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update
RUN apt-get install --yes google-chrome-stable
RUN wget -N http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip && \
 unzip chromedriver_linux64.zip && \
 chmod +x chromedriver && \
 mv -f chromedriver /usr/local/share/chromedriver && \
 ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
 ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
ADD . /data

 
