FROM liuchong/rustup:nightly
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev curl git

RUN apt-get install -y sudo bash gnupg

RUN apt-get install -y pkg-config libssl-dev apt-utils nano

RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

RUN apt-get install -y nodejs 

RUN npm install -g @angular/cli

RUN npm --version
RUN git --version
RUN cargo --version

WORKDIR /.cervisia-server/
WORKDIR /usr/cervisia/frontend/
WORKDIR /usr/cervisia/backend/
WORKDIR /usr/cervisia/

COPY startup.sh /usr/cervisia/
COPY Settings.toml /.cervisia-server/

EXPOSE 8080
ENTRYPOINT  ["/usr/cervisia/startup.sh"]