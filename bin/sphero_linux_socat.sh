#!/bin/bash

NEXT_WAIT_TIME=0
COMMAND="socat FILE:/dev/$2,nonblock,raw,b115200,echo=0 TCP-LISTEN:$1,fork"
until $COMMAND || [ $NEXT_WAIT_TIME -eq 4 ]; do
  echo "retry..."
  sleep $(( NEXT_WAIT_TIME++ ))
done
