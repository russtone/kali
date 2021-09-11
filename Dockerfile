FROM kalilinux/kali-rolling

RUN apt-get update

# Common
RUN apt-get install -y \
  neovim \
  curl \
  build-essential \
  git \
  zsh \
  sed \
  locales \
  net-tools

# Tools
RUN apt-get install -y \
  nmap \
  masscan \
  smbmap \
  enum4linux \
  ruby ruby-dev \
  impacket-scripts \
  crackmapexec

# Ruby-tools
RUN gem install evil-winrm

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM screen-256color

WORKDIR /root

# dotfiles
RUN git clone https://github.com/russtone/dotfiles .config

#
# zsh
#

# configs
RUN ln -s .config/zsh/zshenv .zshenv && \
  rm .zshrc && ln -s .config/zsh/zshrc .zshrc

# load plugins
RUN zsh -ic 'whoami'

# modified prompt
COPY prompt.zsh /root/.prompt
RUN echo 'source $HOME/.prompt' >> ~/.zshrc


ENTRYPOINT ["/usr/bin/zsh"]
