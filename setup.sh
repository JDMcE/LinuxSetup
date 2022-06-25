#!/bin/bash

usage() {
  cat << EOF 
Usage: $(basename "${BASH_SOURCE[0]}") [-h|a|i|s|t|u|z]

A script for installing things.
	-h	Display usage
	-a 	Install all
	-i	Install i3-gaps
	-s	Install Security tool (requires go)
	-g	Install go
	-t	Install Terminator
	-u	Install Sublime Text
	-z	Install zsh/ohmyzsh 

...
EOF
  exit
}


sublimeSetup()
{
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt -y update
	sudo apt install -y sublime-text
}

zshSetup()
{
	sudo apt install -y zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	#Add config 	
	ln -s $HOME/Config-Files/.zshrc $HOME/.zshrc 

	#Add plugins
	cd $HOME/.oh-my-zsh/custom/plugins
	git clone https://github.com/zsh-users/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions
}


i3Setup()
{
	cd $HOME
	sudo add-apt-repository ppa:regolith-linux/release
	sudo apt update
	sudo apt install -y i3-gaps

	sudo apt install -y rofi nitrogen picom compton
	
	#Add config
	cp $HOME/Config-Files/i3config/* $HOME/.config/*
}


terminatorSetup()
{
	sudo apt install -y terminator
	ln -s $HOME/Config-Files/Terminator/config $HOME/.config/terminator/config
}

goInstall()
{	
	wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
	sudo tar -xvf go1.18.2.linux-amd64.tar.gz
	sudo mv go /usr/local
	mkdir $HOME/go
}

secTools()
{

	#create a tools folder in $HOME/
	mkdir $HOME/tools
	cd $HOME/tools/

	#install aquatone
	go install github.com/michenriksen/aquatone@latest


	#JSparser
	git clone https://github.com/nahamsec/JSParser.git
	cd JSParser*
	sudo python setup.py install
	cd $HOME/tools/


	#Sublist3r
	git clone https://github.com/aboul3la/Sublist3r.git
	cd Sublist3r*
	pip install -r requirements.txt
	cd $HOME/tools/


	#teh_s3_bucketeers
	git clone https://github.com/tomdev/teh_s3_bucketeers.git
	cd $HOME/tools/


	#dirsearch
	git clone https://github.com/maurosoria/dirsearch.git
	cd $HOME/tools/


	#lazys3
	git clone https://github.com/nahamsec/lazys3.git
	cd $HOME/tools/


	#Virtual Host Discovery
	git clone https://github.com/jobertabma/virtual-host-discovery.git
	cd $HOME/tools/


	#knock.py
	git clone https://github.com/guelfoweb/knock.git
	cd $HOME/tools/


	#lazyrecon
	git clone https://github.com/nahamsec/lazyrecon.git
	cd $HOME/tools/


	#asnlookup
	git clone https://github.com/yassineaboukir/asnlookup.git
	cd $HOME/tools/asnlookup
	pip install -r requirements.txt
	cd $HOME/tools/


	#crtndstry
	git clone https://github.com/nahamsec/crtndstry.git


	#Seclists
	cd $HOME/tools/
	git clone https://github.com/danielmiessler/SecLists.git
	cd $HOME/tools/SecLists/Discovery/DNS/
	##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
	cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
	cd $HOME/tools/


	#PEAS Suite
	cd $HOME/tools/
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git


	#github-search
	cd $HOME/tools/
	git clone https://github.com/gwen001/github-search.git
	
	#Install go tools
	
	#httprobe
	go install github.com/tomnomnom/httprobe@latest 

	#unfurl
	go install github.com/tomnomnom/unfurl@latest

	#waybackurls
	go install github.com/tomnomnom/waybackurls@latest
	
	#meg
	go install github.com/tomnomnom/meg@latest
	
	#gf
	go install github.com/tomnomnom/gf@latest
	
	#Create empty files for listings
	touch httprobe unfurl waybackurls meg gf


	echo -e "\n\n\n\n\n\n\n\n\n\n\nDone! All tools are set up in $HOME/tools"
	ls -la
	echo "TODO: For Nuclei - Download latest binary from https://github.com/projectdiscovery/nuclei/releases"

}


#Download config files
cd $HOME
if [[ ! -d  "$HOME/Config-Files" ]];then
	git clone http://github.com/JDMcE/Config-Files.git
fi

# Main
while getopts ":haistuzg" option; do
	case $option in 
		h) # Display help
			usage
			exit;;
		a) # Install all
			goInstall
			secTools
			terminatorSetup
			zshSetup
			i3Setup
			sublimeSetup
			;;
		g) # Install go
			goInstall
			;;	
		s) # Install sectools
			secTools
			;;
		t) # Install Terminator
			terminatorSetup
			;;
		z) # Install ZSH
			zshSetup
			;;
		i) # Install i3
			i3Setup
			;;
		u) # Install Sublime text
			sublimeSetup
			;;
		*) # Invalid options
			echo "Error: Invalid argument"
			usage
			;;

	esac
done
