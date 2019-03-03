SHELL := /bin/bash

BEAR=${PWD}/bin/bear
CCLS=${PWD}/bin/ccls
CLANG_DIR=${PWD}/repositories/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04
CLANG=${CLANG_DIR}/bin/clang
CTAGS=${PWD}/bin/ctags
FZY=${PWD}/bin/fzy
NVIM=${PWD}/bin/nvim
PYENV=${PWD}/pyenv/bin/pyenv

all: setup nvim 

nvim: ${NVIM}
${NVIM}: pyenv fzy ctags ccls bear env.sh
	wget "https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage" -O "${PWD}/bin/nvim"
	chmod u+x ${PWD}/bin/nvim
	wget "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "config/nvim/autoload/plug.vim"
	XDG_CONFIG_HOME=${PWD}/config ${PWD}/bin/nvim +PlugInstall

bear: ${BEAR}
${BEAR}: 
	git clone https://github.com/rizsotto/Bear repositories/bear
	cd repositories/bear && cmake . -DCMAKE_INSTALL_PREFIX=${PWD} && make all && make install

pyenv: ${PYENV}
${PYENV}:
	git clone https://github.com/pyenv/pyenv.git ${PWD}/pyenv
	git clone https://github.com/pyenv/pyenv-virtualenv.git ${PWD}/pyenv/plugins/pyenv-virtualenv
	chmod +x ${PWD}/pyenv-setup.sh
	${PWD}/pyenv-setup.sh

ccls: clang ${CCLS} 
${CCLS}:
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls repositories/ccls
	cd repositories/ccls && \
	cmake -DCMAKE_PREFIX_PATH=${CLANG_DIR} -DCMAKE_INSTALL_PREFIX=${PWD} -H. -BRelease && \
	cmake --build Release && \
	cd Release && \
	make install

clang: ${CLANG}
${CLANG}: 
	wget -O- http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz | tar xJ -C ${PWD}/repositories/

fzy: ${FZY}
${FZY}: 
	git clone https://github.com/jhawthorn/fzy.git repositories/fzy
	cd repositories/fzy && make && make PREFIX=${PWD} install

ctags: ${CTAGS}
${CTAGS}:
	@git clone https://github.com/universal-ctags/ctags.git repositories/ctags
	@cd repositories/ctags/ && ./autogen.sh && ./configure --prefix=${PWD} && make && make install

env.sh:
	@echo "###################################### DEVTOOLS #######################################" > ${PWD}/env.sh
	@echo "export PYENV_ROOT=${PWD}/pyenv/" >> ${PWD}/env.sh
	@echo "export PATH=\$${PYENV_ROOT}/bin/:${PWD}/bin:\$${PATH}" >> ${PWD}/env.sh
	@echo "if command -v pyenv 1>/dev/null 2>&1; then\n\teval \"\$$(pyenv init -)\"\n\teval \"\$$(pyenv virtualenv-init -)\"\nfi" >> ${PWD}/env.sh
	@echo "alias n='XDG_CONFIG_HOME=${PWD}/config nvim'" >> env.sh
	@echo "#######################################################################################" >> ${PWD}/env.sh

setup:
	mkdir -p ${PWD}/repositories
	mkdir -p ${PWD}/bin
	mkdir -p ${PWD}/lib
	mkdir -p ${PWD}/lib64
	mkdir -p ${PWD}/share
	/bin/bash ${PWD}/setup.sh

clean:
	rm -rf env.sh
	rm -rf repositories/*
	rm -rf bin/* lib/* lib64/* share/*
	rm -rf config/nvim/plugins/*
	rm -rf config/nvim/autoload/*
