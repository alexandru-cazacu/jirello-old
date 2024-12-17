#!/usr/bin/env sh

if [ "$1" == "mix" ]; then
    exec "$@"
elif [ -n "$1" ]; then
    sh -c "$@"
else
    mix local.hex --force
    mix local.rebar --force
    mix deps.get
    printf "\n"
    mix ecto.reset

    if [ "$MIX_ENV" == "prod" ]; then
        mix ecto.create
        mix ecto.migrate
        mix phx.server
    else
        echo "Skipping server start as MIX_ENV is not set to 'prod'."
        exec tail -f /dev/null
    fi
fi
