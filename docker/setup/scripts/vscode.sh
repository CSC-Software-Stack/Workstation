#!/bin/bash
# VS Code
mkdir -p ~/.config/Code/User/
touch ~/.config/Code/User/settings.json

cp /setup/vscode/settings.json ~/.config/Code/User/settings.json

code --install-extension ms-python.python
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-toolsai.jupyter
code --install-extension ritwickdey.liveserver
code --install-extension wayou.vscode-todo-highlight
code --install-extension vscode-icons-team.vscode-icons
code --install-extension grapecity.gc-excelviewer
code --install-extension oderwat.indent-rainbow
code --install-extension francescaFati.medview
