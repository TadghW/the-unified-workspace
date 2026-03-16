# My silly little workspace container

Builds a container with the utilities, interpreters, compilers, and package managers I work with and installs my shell, tmux, and neovim configs. Exposes container to the network over ssh with key auth so I can share one workspace across multiple devices, pre-authorizes the keys in `authorized_keys` for declarative auth control.

## Notes:
- `start-workspace.sh` and `refresh-workspace.sh` forward port 2222 on your host to 22 on the container so you can skip attaching
- `start-workspace.sh` and `refresh-workspace.sh` ro mount the host's ssh keys for easy authentication across container rebuilds
- There's a little loop in both scripts that looks for keys named id_rsa and id_ed25519 but you can expand that to other encryptions as you need
- `start-workspace.sh` and `refresh-workspace.sh` full mount the host's ~/projects folder because that's where I expect to work

## Customise for yourself!
- `Dockerfile` exposes the arguments: `UID`, `GID`, `USER`, `GROUP`, `USER_GIT_EMAIL`, `USER_GIT_NAME`, `USER_GIT_DEFAULT_BRANCH`
- Replace my `dotfiles` submodule with your own dotfiles
- Remove the `ohmyposh` and `catppuccin-tmux` install lines (unless you want them)
- Replace my `.bashrc` and `.bash_profile` installs with whatever shell you prefer

## To-do:
- Arm64 version for apple silicon
- Workspace currently builds its own host keys at buildtime - this sucks, each rebuild will prompt trip the tamper-warning on your ssh client and require you to clear the old host keys and approve the new ones unless you disable strict-checking (also bad). Ideally `start-workspace.sh` and `refresh-workspace.sh` mount the host's host keys which confer trust from a stable place.
