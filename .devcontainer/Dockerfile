FROM mcr.microsoft.com/devcontainers/base:jammy

RUN apt update 
RUN apt install -y git curl inotify-tools wget 

# Erlang Deps
RUN apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk

# Install Postgres
ENV PGUSER=postgres
ENV PGHOST=127.0.0.1
RUN sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
RUN apt update
RUN apt install -y postgresql-16
# Postgres from anywhere!
RUN sh -c 'echo "host all all all trust" > /etc/postgresql/16/main/pg_hba.conf'

# Install ASDF
RUN git clone https://github.com/asdf-vm/asdf.git /opt/asdf --branch v0.13.1

# install Fly
RUN curl -L https://fly.io/install.sh | sudo -u vscode sh
RUN sh -c 'echo "export FLYCTL_INSTALL=/home/vscode/.fly" >> /home/vscode/.bashrc'
RUN sh -c 'echo "export PATH=\"/home/vscode/.fly/bin:$PATH\"" >> /home/vscode/.bashrc'

# install Elixir and Erlang
ARG ELIXIR_VERSION=1.16.0
ARG ERLANG_VERSION=26.2.1
RUN sh -c 'echo "source /opt/asdf/asdf.sh" >> /home/vscode/.bashrc'
RUN sudo -u vscode bash -c 'source /opt/asdf/asdf.sh && asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git'
RUN sudo -u vscode bash -c "source /opt/asdf/asdf.sh && asdf install erlang $ERLANG_VERSION && asdf global erlang $ERLANG_VERSION"
RUN sudo -u vscode bash -c 'source /opt/asdf/asdf.sh && asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git'
RUN sudo -u vscode bash -c "source /opt/asdf/asdf.sh && asdf install elixir $ELIXIR_VERSION && asdf global elixir $ELIXIR_VERSION"

# install NodeJS and Yarn
ARG NODEJS_VERSION=21.6.1
RUN sudo -u vscode bash -c 'source /opt/asdf/asdf.sh && asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git'
RUN sudo -u vscode bash -c "source /opt/asdf/asdf.sh && asdf install nodejs $NODEJS_VERSION && asdf global nodejs $NODEJS_VERSION"
RUN sudo -u vscode bash -c 'source /opt/asdf/asdf.sh && npm install --global yarn'

# locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

CMD ["/bin/bash"]