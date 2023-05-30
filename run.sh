#!/bin/bash

# 2023-05-30 PJ:
# --------------
# Using this script, this application is not intended to build or run directly on the hosting machine.
# Instead, use docker for that purpose.

docker build -t paket-nix -f ./dockerfile ./ &&
  docker run -it --rm paket-nix