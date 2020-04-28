#!/bin/bash

set -e
set -x

kind delete cluster --name a
kind delete cluster --name b

