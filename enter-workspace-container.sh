#!/bin/bash
sudo podman run --name workspace-container --volume ~/projects:/home/tadgh/projects --volume ~/.ssh/id_ed25519:ro --volume ~/.ssh/id_ed25519.pub:ro --publish 127.0.0.1:2222:22/udp --interactive --tty workspace-image

