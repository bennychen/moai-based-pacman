#!/bin/bash

export MOAI_BIN=~/Workspace/Moai/moai-sdk/bin/osx
export MOAI_CONFIG=~/Workspace/Moai/moai-sdk/samples/config

$MOAI_BIN/moai $MOAI_CONFIG/config.lua main.lua
