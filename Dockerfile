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
  locales

# Tools
RUN apt-get install -y \
  nmap \
  masscan \
  smbmap \
  enum4linux \
  hashcat \
  john

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

# zplug
# see: https://github.com/zplug/zplug/issues/272
COPY zplug-pipe-fix.patch /tmp
RUN git clone https://github.com/zplug/zplug.git ~/.zplug
RUN patch ~/.zplug/base/core/add.zsh /tmp/zplug-pipe-fix.patch
RUN zsh -ic 'ZPLUG_PIPE_FIX=true zplug install'

# modified prompt
COPY prompt.zsh /root/.prompt
RUN echo 'source $HOME/.prompt' >> ~/.zshrc

ENTRYPOINT ["/usr/bin/zsh"]
