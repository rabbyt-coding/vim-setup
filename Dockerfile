FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y software-properties-common git curl tmux silversearcher-ag binutils bison gcc make ncurses-dev build-essential ripgrep
# install latest vim
RUN add-apt-repository ppa:jonathonf/vim && apt-get update && apt-get install -y vim

COPY ./index.js /nodejs/index.js

COPY ./main.go /golang/src/test/main.go

# tmux affecting vim colorscheme
RUN echo 'alias tmux="TERM=screen-256color-bce tmux"' >> /root/.bashrc

# setup nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm ' >> /root/.bashrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# RUN export NVM_DIR="$HOME/.nvm"
RUN NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install 16.0.0 && nvm use 16.0.0 --default && npm install -g yarn

RUN echo 'export GOPATH; GOPATH="/root/.gvm/pkgsets/go1.4/global/overlay:/golang/"' >> /root/.bashrc
RUN echo 'export PATH; PATH="/root/.gvm/pkgsets/go1.4/global/overlay/bin:${GVM_OVERLAY_PREFIX}/bin:/golang/:${PATH}"' >> /root/.bashrc

RUN curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash

ENV GVM_ROOT="$HOME/.gvm"
RUN GVM_ROOT="$HOME/.gvm" &&  [ -s "$GVM_ROOT/scripts/gvm" ] && $GVM_ROOT/bin/gvm install go1.4 -B
