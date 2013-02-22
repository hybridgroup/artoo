#!/bin/bash

NEXT_WAIT_TIME=0
COMMAND="socat PIPE:/dev/tty.Sphero-$1-RN-SPP,nonblock TCP-LISTEN:$2,fork"
until $COMMAND || [ $NEXT_WAIT_TIME -eq 4 ]; do
  echo "retry..."
  sleep $(( NEXT_WAIT_TIME++ ))
done
