#!/bin/bash

#############
# Help		#
#############

Help()
{
	echo "Installs stuff"
	echo "Sytax: setup.sh [-a|h|i|s|t|u|z]"
	echo "Options: "
	echo "	a    Install all"
	echo "	h    Display Help"
	echo "	i    Install i3-gaps"
	echo "	s    Install Security tools"
	echo "	t    Install Terminator"
	echo "	u    Install Sublime Text"
	echo "	z    Install zsh/ohmyzsh"
}

################
# Sublime text #
################


sublimeSetup()
{
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt -y update
	sudo apt install -y sublime-text
}

#############
# zsh		#
#############
zshSetup()
{
	sudo apt install -y zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	cd ~
	git clone https://github.com/JDMcE/Config-Files.git
	cd Config-Files
	mv .zshrc ~/.zshrc
}


#############
# i3-gaps	#
#############
i3Setup()
{
	cd ~
	sudo add-apt-repository ppa:regolith-linux/release
	sudo apt update
	sudo apt install -y i3-gaps

	sudo apt install -y rofi nitrogen picom compton


	git clone https://github.com/JDMcE/i3config.git
	cd i3config
	mv * ~/.config/*
}


#############
# Terminator#
#############
terminatorSetup()
{
	# TODO: add config file
	sudo apt install -y terminator
}


#############
# Sec Tools #
#############
secTools()
{
	#install go
	if [[ -z "$GOPATH" ]];then
	echo "It looks like go is not installed, would you like to install it now"
	PS3="Please select an option : "
	choices=("yes" "no")
	select choice in "${choices[@]}"; do
	        case $choice in
	                yes)

						echo "Installing Golang"
						#wget https://golang.org/dl/go1.15.7.linux-amd64.tar.gz
						#sudo tar -xvf go1.15.7.linux-amd64.tar.gz
						#sudo mv go /usr/local
						sudo apt install -y golang
						export GOROOT=/usr/local/go
						export GOPATH=$HOME/go
						export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
						echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
						echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
						echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile	
						source ~/.bash_profile
						sleep 1
						break
						;;
					no)
						echo "Please install go and rerun this script"
						echo "Aborting installation..."
						exit 1
						;;
		esac	
	done
	fi



	#create a tools folder in ~/
	mkdir ~/tools
	cd ~/tools/

	#install aquatone
	go get github.com/michenriksen/aquatone


	#JSparser
	git clone https://github.com/nahamsec/JSParser.git
	cd JSParser*
	sudo python setup.py install
	cd ~/tools/


	#Sublist3r
	git clone https://github.com/aboul3la/Sublist3r.git
	cd Sublist3r*
	pip install -r requirements.txt
	cd ~/tools/


	#teh_s3_bucketeers
	git clone https://github.com/tomdev/teh_s3_bucketeers.git
	cd ~/tools/


	#dirsearch
	git clone https://github.com/maurosoria/dirsearch.git
	cd ~/tools/


	#lazys3
	git clone https://github.com/nahamsec/lazys3.git
	cd ~/tools/


	#Virtual Host Discovery
	git clone https://github.com/jobertabma/virtual-host-discovery.git
	cd ~/tools/


	#knock.py
	git clone https://github.com/guelfoweb/knock.git
	cd ~/tools/


	#lazyrecon
	git clone https://github.com/nahamsec/lazyrecon.git
	cd ~/tools/


	#asnlookup
	git clone https://github.com/yassineaboukir/asnlookup.git
	cd ~/tools/asnlookup
	pip install -r requirements.txt
	cd ~/tools/


	#httprobe
	go get -u github.com/tomnomnom/httprobe 


	#unfurl
	go get -u github.com/tomnomnom/unfurl 


	#waybackurls
	go get github.com/tomnomnom/waybackurls


	#crtndstry
	git clone https://github.com/nahamsec/crtndstry.git


	#Seclists
	cd ~/tools/
	git clone https://github.com/danielmiessler/SecLists.git
	cd ~/tools/SecLists/Discovery/DNS/
	##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
	cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
	cd ~/tools/



	#PEAS Suite
	cd ~/tools/
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git


	#github-search
	cd ~/tools/
	git clone https://github.com/gwen001/github-search.git


	echo -e "\n\n\n\n\n\n\n\n\n\n\nDone! All tools are set up in ~/tools"
	ls -la
	echo "TODO: For Nuclei - Download latest binary from https://github.com/projectdiscovery/nuclei/releases"

}

#############
# Main		#
#############


while getopts ":haistuz" option; do
	case $option in 
		h) #Display help
			Help
			exit;;
		a) #Install all
			secTools
			terminatorSetup
			zshSetup
			i3Setup
			sublimeSetup
			;;
		s) #Install sectools
			secTools
			;;
		t) #Install Terminator
			terminatorSetup
			;;
		z) #Install ZSH
			zshSetup
			;;
		i) # Install i3
			i3Setup
			;;
		u) # Install Sublime text
			sublimeSetup
			;;
		
		\?) #Invalid options
			echo "Error: Invalid argument"
			Help
			exit;;

	esac
done
