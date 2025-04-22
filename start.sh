#!/bin/bash

# loop directories
for dir in */; do
  stow -Rv $dir
  #stow -D $dir
done
