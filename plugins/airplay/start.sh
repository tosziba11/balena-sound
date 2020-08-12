#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# Set the device broadcast name for AirPlay
if [[ -z "$SOUND_DEVICE_NAME" ]]; then
  SOUND_DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Use pipe output if multi room is enabled
# Don't pipe for Pi 1/2 family devices since snapcast-server is disabled by default
if [[ -z $DISABLE_MULTI_ROOM ]] && ! [[ $BALENA_DEVICE_TYPE == "raspberry-pi" || $BALENA_DEVICE_TYPE == "raspberry-pi2" ]]; then
  SHAIRPORT_BACKEND="-o pipe -- /var/cache/snapcast/snapfifo"
fi

# Start AirPlay
exec shairport-sync -a "$SOUND_DEVICE_NAME" $SHAIRPORT_BACKEND | printf "Device is discoverable as \"%s\"\n" "$SOUND_DEVICE_NAME"