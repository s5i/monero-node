# monero-node

monero-node is a Docker image containing a [Monero](https://getmonero.org) daemon.

## Installation

```sh
# Set as desired.
export MONERO_PATH="/monero"  # Note: should live on an SSD to achieve reasonable performance.
export MONERO_CONTAINER="monero-node"

# Absolutify the path (required for docker volume spec).
export MONERO_PATH=$(readlink -f ${MONERO_PATH})

# Create the directories, download the basic monerod config and the compose file.
mkdir -p ${MONERO_PATH} ${MONERO_PATH}/data ${MONERO_PATH}/log
wget https://raw.githubusercontent.com/s5i/monero-node/refs/heads/master/monerod.conf -O ${MONERO_PATH}/monerod.conf
wget https://raw.githubusercontent.com/s5i/monero-node/refs/heads/master/compose.yaml -O ${MONERO_PATH}/compose.yaml

# Optional: edit the daemon config.
"${EDITOR:-vi}" ${MONERO_PATH}/monerod.conf

# Start the container.
docker compose -f ${MONERO_PATH}/compose.yaml up --pull=always --force-recreate --detach
```