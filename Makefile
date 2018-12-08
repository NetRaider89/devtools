all: nvim 

nvim: fzy ctags ccls bear
	wget "https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage" -O "nvim"
	chmod u+x nvim
	wget "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "nvim.config/nvim/autoload/plug.vim"
	./nvim +PlugInstall

bear:
	git clone https://github.com/rizsotto/Bear repositories/bear-github
	cd repositories/bear-github && cmake . -DCMAKE_INSTALL_PREFIX=${PWD} && make all && make install

ccls:
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls repositories/ccls-github
	cd repositories/ccls-github && cmake -DCMAKE_INSTALL_PREFIX=${PWD} -H. -BRelease && cmake --build Release && cd Release && make install

fzy: 
	git clone https://github.com/jhawthorn/fzy.git repositories/fzy-github
	cd repositories/fzy-github/ && make && make PREFIX=${PWD} install

ctags:
	git clone https://github.com/universal-ctags/ctags.git repositories/ctags-github
	cd repositories/ctags-github/ && ./autogen.sh && ./configure --prefix=${PWD} && make && make install

snippet:
	@echo ""
	@echo ""
	@echo ""
	@echo "###################### PASTE THIS SNIPPET IN YOUR .bashrc FILE #######################"
	@echo "export PATH=\$${PATH}:${PWD}:${PWD}/bin"
	@echo "######################################################################################"
	@echo ""
	@echo ""
	@echo ""


clean:
	rm -rf repositories/*
	rm -rf bin/* lib/* lib64/* share/*
	rm -rf nvim.config/nvim/plugins/*
	rm -rf nvim.config/nvim/autoload/*
	rm -rf nvim
