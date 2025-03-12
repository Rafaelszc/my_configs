all: fedora_config gitig
	@echo "Installing all"

fedora_config:
	chmod +x linux/fedora_config.sh
	linux/fedora_config.sh

gitig:
	chmod +x linux/gitig/gitig_func.sh
	linux/gitig/gitig_func.sh

	source ~/.bashrc
