#!/bin/bash

# Extract all installed extensions in comfortable output
code --list-extensions | xargs -L 1 echo code --install-extension
