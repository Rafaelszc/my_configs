#!/bin/bash

# Um código para colocar o alias do gitig CLI
# no arquivo .bashrc
#
# Novamente, divirta-se!

bash_path="$HOME/.bashrc"
cli_path="$(cd "$(dirname "$0")" && pwd)/gitig_cli.py"

func="gitig(){ python $cli_path \"\$@\"; }"


if ! grep -q "gitig" $bash_path;
then
    echo "$func" >> "$bash_path"
else
    echo "gitig is currently in .bashrc"
fi
