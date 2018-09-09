all: nvim 

nvim: fzy ctags 
	wget "https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage" -O "nvim"
	chmod u+x nvim
	wget "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "nvim.config/nvim/autoload/plug.vim"
	./nvim +PlugInstall

fzy: 
	wget -O- "https://github.com/jhawthorn/fzy/archive/0.9.tar.gz" | tar xz
	cd fzy*/ && make && cp fzy ${PWD}/fzy

ctags:
	wget "https://codeload.github.com/universal-ctags/ctags/zip/master" -O "ctags.zip" && unzip -o ctags.zip && rm ctags.zip 
	cd ctags*/ && ./autogen.sh && ./configure && make &&  cp ctags ${PWD}/ctags

snippet:
	@echo ""
	@echo ""
	@echo ""
	@echo "####################### PASTE THIS SNIPPET IN YOUR .bashrc FILE #######################"
	@echo "export PATH=\$${PATH}:${PWD}"
	@echo "#######################################################################################"
	@echo ""
	@echo ""
	@echo ""


clean:
	rm -rf fzy*/ fzy
	rm -rf ctags*/ ctags
	rm -rf nvim.config/nvim/plugins/*
	rm -rf nvim.config/nvim/autoload/*
	rm -rf nvim
