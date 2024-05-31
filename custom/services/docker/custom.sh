#!/usr/bin/env bash

/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
echo 'Docker service started!'