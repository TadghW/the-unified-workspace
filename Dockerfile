FROM alpine:3.23.3

ARG UID=1000
ARG GID=1000
ARG HOST_USER=tadgh
ENV LANG=C.UTF-8
ENV LC_CTYPE=C.UTF-8

RUN apk add --no-cache \
  bash \
  musl-locales musl-locales-lang \
  neovim \
  sudo \
  tmux \
  fzf \
  ripgrep \
  curl \
  wget \
  openssh \
  git \
  go \
  rust \
  nodejs \
  npm \
  podman \
  python3 

RUN adduser -D -s /bin/bash -u ${UID} -g root ${HOST_USER}

# Very damgerous don't do outside of a silly work container
RUN echo "${HOST_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${HOST_USER} && chmod 0440 /etc/sudoers.d/${HOST_USER}

USER ${HOST_USER}

RUN curl -s https://ohmyposh.dev/install.sh | bash -s

RUN mkdir ~/dotfiles ~/.config
COPY --chown=${HOST_USER}:root ./dotfiles /home/${HOST_USER}/dotfiles

RUN cp ~/dotfiles/.bashrc-auto-tmux ~/.bashrc

RUN cp -r ~/dotfiles/nvim ~/dotfiles/tmux ~/.config
RUN git clone --quiet -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

RUN git config --global user.email "tadgh@tadghwagstaff.com"
RUN git config --global user.name "Tadgh"
RUN git config --global init.defaultBranch "main"

WORKDIR /home/${HOST_USER}
ENTRYPOINT ["/bin/bash"]
