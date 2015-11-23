set -o errexit
set -o nounset
set -o noclobber

BASE_NAME=${BASE_NAME:-$(basename $0)}
BASE_DIR=${BASE_DIR:-$(dirname $BIN_DIR)}

DOCKER=${DOCKER:-$(command -v docker || echo "Docker command not found in path")}
DOCKER_IMAGES=${DOCKER_DIR:-$BASE_DIR/docker/images}

COMPOSE=${COMPOSE:-$(command -v docker-compose || echo "Docker command not found in path")}
COMPOSE_PROJECT=rt4

function trap_err() {
  ERRNO=${1:-}
  if [ "xx$ERRNO" != "xx" ] && [ $ERRNO != "0" ]; then
    SI=$((${#BASH_LINENO[@]}-2))
    echo " - $BASE_NAME/error: ${BASH_SOURCE[$SI+1]}:${BASH_LINENO[$SI]}:${FUNCNAME[$SI]}"
    exit 127
  fi
};

trap 'trap_err "$?"' ERR
trap 'exit 1' QUIT INT