#!/bin/bash

# Um arquivozinho com as configs que eu gosto do fedora
# Sei que o código pode estar porco, mas depois melhoro
#
# Divirta-se!
#
# Author: Rafaelszc
# Github: https://github.com/Rafaelszc
#

# Pyhton pip packages

PIP_PACKAGES=(
	"requests"
	"beautifulsoup4"
	"selenium"
	"scikit-learn"
	"pandas"
	"seaborn"
	"discord"
	"flask"
	"click"
)

# Flatpak programs list

FLATPAK_PROGRAMS=(
	"app.zen_browser.zen"
	"com.github.johnfactotum.Foliate"
	"com.google.AndroidStudio"
	"com.jeffser.Alpaca"
	"com.jetbrains.IntelliJ-IDEA-Community"
	"com.obsproject.Studio"
	"com.spotify.Client"
	"com.valvesoftware.Steam"
	"dev.vencord.Vesktop"
	"io.github.alainm23.planify"
	"io.gitlab.news_flash.NewsFlash"
	"io.missioncenter.MissionCenter"
	"md.obsidian.Obsidian"
	"org.gnome.Builder"
	"org.qbittorrent.qBittorrent"
	"org.kde.krita"
	"com.visualstudio.code"
)

# List of GNOME extensions repo

GNOME_EXTENSIONS=(
	"https://github.com/stuarthayhurst/alphabetical-grid-extension.git"
	"https://github.com/eonpatapon/gnome-shell-extension-caffeine.git"
	"https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git"
	"https://github.com/tuberry/extension-list.git"
)

# List of vscode's extensions

VSCODE_EXTENSIONS=(
	"davidanson.vscode-markdownlint"
	"esbenp.prettier-vscode"
	"grapecity.gc-excelviewer"
	"miguelsolorio.min-theme"
	"miguelsolorio.symbols"
	"ms-azuretools.vscode-docker"
	"ms-python.debugpy"
	"ms-python.python"
	"ms-python.vscode-pylance"
	"ms-toolsai.jupyter"
	"ms-toolsai.jupyter-keymap"
	"ms-toolsai.jupyter-renderers"
	"ms-toolsai.vscode-jupyter-cell-tags"
	"ms-toolsai.vscode-jupyter-slideshow"
	"ms-vscode.cmake-tools"
	"ms-vscode.cpptools"
	"ms-vscode.cpptools-extension-pack"
	"ms-vscode.cpptools-themes"
	"ms-vscode.live-server"
	"oderwat.indent-rainbow"
	"oracle.oracle-java"
	"qwtel.sqlite-viewer"
	"redhat.java"
	"ritwickdey.liveserver"
	"twxs.cmake"
	"visualstudioexptteam.intellicode-api-usage-examples"
	"visualstudioexptteam.vscodeintellicode"
	"vscjava.vscode-gradle"
	"vscjava.vscode-java-debug"
	"vscjava.vscode-java-dependency"
	"vscjava.vscode-java-pack"
	"vscjava.vscode-java-test"
	"vscjava.vscode-maven"
	"yzhang.markdown-all-in-one"
)

# Orchis Theme repo

THEME_URL="https://github.com/vinceliuice/Orchis-theme.git"

# Functions to install some things

get_repo_name () {
        reponame=$(basename "$1" .git)
        echo $reponame
}

install_extension () {
	reponame=$(get_repo_name "$1")

	git clone "$1"
	cd "$reponame"
	make all
	cd ..
	rm -rf "$reponame"
}

# Setting GNOME config

## Theme

dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

## Power profile

dconf write /org/gnome/shell/last-selected-power-profile "'performance'"

## Keyboard and mouse

dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'us+alt-intl')]"
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"

## Keybinds

dconf write /org/gnome/desktop/wm/keybindings/switch-applications "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Control>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'ptyxis --new-window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Open Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

# Updating system

sudo dnf update -y

# Installing python pip packages

pip install "${PIP_PACKAGES[@]}"

# Installing Flatpak Flathub if doesnt exists

sudo dnf install flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Installing Flatpak programs

for program in "${FLATPAK_PROGRAMS[@]}";
do
	flatpak install "$program"
done

# Installing GNOME extensions

sudo dnf install gnome-extensions-app

for extension in "${GNOME_EXTENSIONS[@]}";
do
	install_extension "$extension"
done

EXT_LIST_URL="https://github.com/tuberry/extension-list.git"

git clone "$EXT_LIST_URL"

ext_list_reponame=$(get_repo_name "$EXT_LIST_URL")

cd "$ext_list_reponame"

meson setup build && meson install -C build

cd ..

rm -rf "$ext_list_reponame"

# Installing GNOME theme

git clone "$THEME_URL"

theme_name=$(get_repo_name "$THEME_URL")

cd "$theme_name"
./install.sh -t purple -c dark -s compact -i simple --tweaks black
cd ..
rm -rf "$theme_name"

# Installing vscode extensions

for extension in "${VSCODE_EXTENSIONS[@]}";
do
	flatpak run com.visualstudio.code --install-extension "$extension"
done

# Installing Anaconda

chmod +x Anaconda3-2024.10-1-Linux-x86_64.sh

./Anaconda3-2024.10-1-Linux-x86_64.sh

rm -rf /Anaconda3-2024.10-1-Linux-x86_64.sh