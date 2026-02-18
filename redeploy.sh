#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_NAME="${1:-traefik}"
COMPOSE_FILE="${SCRIPT_DIR}/docker-stack.yml"

echo "=== Eliminando stack '${STACK_NAME}'..."
docker stack rm "${STACK_NAME}"

echo "=== Esperando a que el stack se elimine por completo..."
while docker stack services "${STACK_NAME}" &>/dev/null; do
  sleep 2
done
# Dar tiempo extra a que los contenedores terminen
sleep 3

echo "=== Desplegando stack '${STACK_NAME}'..."
cd "${SCRIPT_DIR}"
docker stack deploy -c "${COMPOSE_FILE}" "${STACK_NAME}"

echo "=== Listo. Servicios:"
docker stack services "${STACK_NAME}"
