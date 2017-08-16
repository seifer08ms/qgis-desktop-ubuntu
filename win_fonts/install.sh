#!/bin/bash
sudo cp ./* /usr/share/fonts
cd /usr/share/fonts
sudo mkfontscale
sudo mkfontdir
sudo fc-cache
