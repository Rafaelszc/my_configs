#!/bin/bash

# Um arquivozinho com as configs que eu gosto do fedora
# Sei que o código pode estar porco, mas depois melhoro
#
# Divirta-se!
#
# Author: Rafaelszc
# Github: https://github.com/Rafaelszc
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
	"com.getpostman.Postman"
	"com.github.johnfactotum.Foliate"
	"com.google.AndroidStudio"
	"com.jeffser.Alpaca"
	"com.jetbrains.IntelliJ-IDEA-Community"
	"com.obsproject.Studio"
	"com.spotify.Client"
	"com.valvesoftware.Steam"
	"com.visualstudio.code"
	"dev.vencord.Vesktop"
	"io.github.alainm23.planify"
	"io.gitlab.news_flash.NewsFlash"
	"io.missioncenter.MissionCenter"
	"md.obsidian.Obsidian"
	"org.gnome.Builder"
	"org.gnome.World.PikaBackup"
	"org.qbittorrent.qBittorrent"
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
	"adpyke.codesnap"
	"bradlc.vscode-tailwindcss"
	"davidanson.vscode-markdownlint"
	"docker.docker"
	"esbenp.prettier-vscode"
	"foxundermoon.shell-format"
	"grapecity.gc-excelviewer"
	"miguelsolorio.min-theme"
	"miguelsolorio.symbols"
	"ms-azuretools.vscode-containers"
	"ms-azuretools.vscode-docker"
	"ms-python.debugpy"
	"ms-python.python"
	"ms-python.vscode-pylance"
	"ms-toolsai.datawrangler"
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
	"qwtel.sqlite-viewer"
	"ritwickdey.liveserver"
	"twxs.cmake"
	"yzhang.markdown-all-in-one"
)

UNTIL_PROGRAMS=(
	"firefox.x86_64"
	"gnome-weather.noarch"
	"resctl-demo.x86_64"
	"rhythmbox.x86_64"
	"malcontent.x86_64"
	"gnome-characters.x86_64"
	"gnome-contacts.x86_64"
	"gnome-tour.x86_64"
	"elementary-camera.x86_64"
	"gnome-maps.x86_64"
)

# Orchis Theme repo

THEME_URL="https://github.com/vinceliuice/Orchis-theme.git"

# Functions to install some things

get_repo_name () {
	local reponame
	reponame=$(basename "$1" .git)
	echo "$reponame"
}

install_extension () {
	local repo_url="$1"
	local reponame
	local temp_dir
	reponame=$(get_repo_name "$repo_url")
	temp_dir=$(mktemp -d)

	git clone --depth 1 "$repo_url" "$temp_dir/$reponame"
	pushd "$temp_dir/$reponame" > /dev/null

	if [ -f "meson.build" ];
	then
		meson setup build --prefix "$HOME/.local"
		meson install -C build
	else
		make install PREFIX="$HOME/.local"
	fi

	popd > /dev/null
	rm -rf "$temp_dir"
}

enable_installed_gnome_extensions () {
	local extension_dir
	local uuid

	if ! command -v gnome-extensions > /dev/null 2>&1;
	then
		echo "gnome-extensions command not found; extensions were installed but not enabled."
		return 0
	fi

	for extension_dir in "$HOME"/.local/share/gnome-shell/extensions/*;
	do
		[ -d "$extension_dir" ] || continue
		uuid=$(basename "$extension_dir")

		if ! gnome-extensions enable "$uuid" > /dev/null 2>&1;
		then
			echo "Could not enable $uuid automatically. Log out/in and enable it with GNOME Extensions."
		fi
	done
}

install_gnome_theme () {
	local theme_name
	local temp_dir
	local installed_theme

	temp_dir=$(mktemp -d)
	theme_name=$(get_repo_name "$THEME_URL")

	git clone --depth 1 "$THEME_URL" "$temp_dir/$theme_name"
	pushd "$temp_dir/$theme_name" > /dev/null
	./install.sh -t purple -c dark -s compact -i simple --tweaks black
	popd > /dev/null
	rm -rf "$temp_dir"

	installed_theme=$(find "$HOME/.themes" "$HOME/.local/share/themes" /usr/share/themes \
		-maxdepth 1 -type d -name "Orchis*Purple*Dark*Compact*" 2> /dev/null | head -n 1)

	if [ -n "$installed_theme" ];
	then
		gsettings set org.gnome.desktop.interface gtk-theme "$(basename "$installed_theme")"
	fi
}

install_gitig_shell_integration () {
	"$SCRIPT_DIR/gitig/gitig_func.sh"
}

uninstall_dnf_apps () {
	for app in "${UNTIL_PROGRAMS[@]}";
	do
		sudo dnf remove -y "$app"
	done
}

# Login configs
EMAIL=""
GITHUB_NAME=""

get_email () {
	regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

        read -p "Type your email address: " EMAIL

       	if  [[ "$EMAIL" =~ $regex ]]
        then
            	echo "user email: $EMAIL"
        else
            	echo "Invalid value, try again"
                get_email
        fi
}

get_github_name () {
	read -s -p "Type your github username: " GITHUB_NAME

	if [ -n "$GITHUB_NAME" ]
	then
		echo
	else
		echo "Invalid value, try again"
		get_github_name
	fi
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

# Getting email

get_email

# Getting GitHub username

get_github_name

# Creating ssh key

ssh-keygen -t ed25519 -C "$EMAIL"

# Git and github configs

git config --global user.email "$EMAIL"
git config --global user.name "$GITHUB_NAME"

sudo dnf install -y gh fish && gh auth login

# Updating system

sudo dnf update -y

# Installing python pip packages

sudo dnf install -y python3-pip

python3 -m pip install --user "${PIP_PACKAGES[@]}"

# Installing Flatpak Flathub if doesnt exists

sudo dnf install -y flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Installing Flatpak programs

for program in "${FLATPAK_PROGRAMS[@]}";
do
	flatpak install -y flathub "$program"
done

# Installing GNOME extensions

sudo dnf install -y git make meson ninja-build gettext glib2-devel gnome-extensions-app sassc gtk-murrine-engine gnome-themes-extra

for extension in "${GNOME_EXTENSIONS[@]}";
do
	install_extension "$extension"
done

enable_installed_gnome_extensions

# Installing GNOME theme

install_gnome_theme

# Installing gitig for Bash and Fish

install_gitig_shell_integration

# Installing vscode extensions

for extension in "${VSCODE_EXTENSIONS[@]}";
do
	flatpak run com.visualstudio.code --install-extension "$extension"
done

# Removing until default fedora apps

uninstall_dnf_apps
