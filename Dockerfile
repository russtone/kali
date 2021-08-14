FROM kalilinux/kali-rolling

RUN apt-get update

# Common
RUN apt-get install -y \
  neovim \
  curl \
  # build-essential \
  git \
  zsh \
  sed \
  locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM screen-256color

# Tools
# RUN apt-get install -y \
#   nmap \
#   masscan \
#   smbmap \
#   enum4linux \
#   hashcat \
#   john

# dotfiles
RUN git clone https://github.com/russtone/dotfiles ~/.config

# zsh
RUN ln -s ~/.config/zsh/zshenv ~/.zshenv && \
  rm ~/.zshrc && ln -s ~/.config/zsh/zshrc ~/.zshrc
RUN zsh -csi 'zplug install'
COPY prompt.zsh /root
RUN echo 'source ~/prompt.zsh' >> ~/.zshrc

ENTRYPOINT ["/usr/bin/zsh"]
