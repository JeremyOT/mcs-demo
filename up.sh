#!/bin/bash

set -e
set -x

kind create cluster --config a.yaml --name a
kind create cluster --config b.yaml --name b

