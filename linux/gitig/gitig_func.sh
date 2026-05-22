#!/bin/bash

# Instala a funcao gitig nos shells interativos suportados.

set -e

bash_path="$HOME/.bashrc"
fish_functions_dir="$HOME/.config/fish/functions"
fish_path="$fish_functions_dir/gitig.fish"
cli_path="$(cd "$(dirname "$0")" && pwd)/gitig_cli.py"

install_bash_function () {
    touch "$bash_path"

    # Remove a versao antiga, que era gravada sem marcadores.
    sed -i '\|^gitig(){ python .*/gitig_cli.py "\$@"; }$|d' "$bash_path"
    sed -i '\|^gitig(){ python3 .*/gitig_cli.py "\$@"; }$|d' "$bash_path"

    if grep -q "# >>> gitig >>>" "$bash_path"; then
        sed -i '/# >>> gitig >>>/,/# <<< gitig <<</d' "$bash_path"
    fi

    {
        echo
        echo "# >>> gitig >>>"
        echo "gitig(){ python3 \"$cli_path\" \"\$@\"; }"
        echo "# <<< gitig <<<"
    } >> "$bash_path"

    echo "gitig installed in $bash_path"
}

install_fish_function () {
    mkdir -p "$fish_functions_dir"

    {
        echo "function gitig"
        echo "    python3 \"$cli_path\" \$argv"
        echo "end"
    } > "$fish_path"

    echo "gitig installed in $fish_path"
}

install_bash_function
install_fish_function
