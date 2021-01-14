#!/bin/bash

echo -n Your Age:
read AGE

[ $AGE -lt 20  ] && { echo you are not allowed to see the secret; exit 1; } || echo Welcme

echo "Secret is that there is no secret"
