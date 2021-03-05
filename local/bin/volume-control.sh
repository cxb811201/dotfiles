#!/usr/bin/env bash
set -euo pipefail

pulsemixer

pkill -RTMIN+10 dwmblocks
