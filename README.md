# The Unified Workspace

## This project

- Builds a tiny image with:
    - The utilities, compilers, interpreters, and package managers I use. 
    - My shell, tmux, and neovim configs.
    - Git, podman, and OpenSSH
    - A single admin user with passwordless sudo
    - Pubkey ssh login access to that user for all clients in `authorized_keys`
- Starts a container that:
    - Mounts the hosts ssh keys
    - Mounts the hosts `~\projects` folder
    - Exposes the container's SSH port to the `:22222` on the host

This environment lives on my homeserver and is used as a single workspace that can be accessed by my household's many clients. It offers a declarative, atomic environment that unites each of my devices into one tmux session and one set of git worktree states. 

## To deploy

### Requirements

To deploy the unified workspace you will need a relatively modern x86 Linux host with:
 - Sudo
 - Podman
 - Static network address (_I recommend a DHCP entry, netbios name, or local DNS entry - avoid exposing this to the internet as it mounts the host's private key_)

### Steps

On your intended host:

1. `git clone https://github.com/TadghW/workspace-container.git`
2. `cd workspace-container`
3. `git submodule update --init --recursive` (see "Customise!" if you don't want my config)
4.  Set the `USER`, `USER_GIT_EMAIL`, and `USER_GIT_NAME` `ARG`s at the top of `Dockerfile`
5.  Populate `authorized_keys` with the public ssh keys of the client devices you intend to access the space with
6.  Replace the network address in `start-workspace.sh` and `refresh-workspace.sh` with the address you intend to use
7.  Run `build-workspace-image.sh` and `start-workspace.sh` - (or one-shot it with `refresh-workspace.sh`!)

## Notes
- `sshd` is the container entrypoint and `start-workspace.sh` and `refresh-workspace.sh` assume you want port forwarding for easy access - but you can attach with `attach-to-workspace.sh` if you want to run locally
- `sshd` is run with flags `-D -e` and will pipe logs to stderr - if you run into issues accessing the workspace over SSH check the logs from the host with `sudo podman logs workspace-container`
- `start-workspace.sh` and `refresh-workspace.sh` rw mount the host's ~/projects folder because that's where I expect to work, that's not a magic folder just my personal convention
- There's a little loop in both scripts that checks the host for ssh keys named id_rsa and id_ed25519 to mount to the container (ro). Add another keyname to that list to enable them to mount different encryption standards.

## Customise!

To customise the workspace:

- `Dockerfile` exposes the arguments: `UID`, `GID`, `USER`, `GROUP`, `USER_GIT_EMAIL`, `USER_GIT_NAME`, `USER_GIT_DEFAULT_BRANCH`
- Make sure you have all of the packages you want on the apk install list in at the top of the `Dockerfile`
- Replace my `dotfiles` submodule with your own dotfiles
- Remove the `ohmyposh` and `catppuccin-tmux` install lines (unless you want them)
- Replace my `.bashrc` and `.bash_profile` installs with whatever shell you prefer
- Replace my `authorized_keys` file with your own list of trusted devices

## To-do:
- It would be painless and fruitful to expand the list of key types assembled in `start-workspace.sh` and `refresh-workspace.sh`
- Workspace currently builds its own host keys at buildtime - this sucks, each rebuild will prompt trip the tamper-warning on your ssh client and require you to clear the old host keys and approve the new ones unless you disable strict-checking (also bad). Ideally `start-workspace.sh` and `refresh-workspace.sh` mount the host's host keys which confer trust from a stable place.
- Arm64 version for Apple Silicone
