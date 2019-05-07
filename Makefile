SHELL:=/bin/bash

CTAGS=${PWD}/bin/ctags
FZY=${PWD}/bin/fzy
PYENV=${PWD}/pyenv/bin/pyenv
NVIM=${PWD}/bin/nvim

# TODO: add other os checks as necessary refer to
# https://unix.stackexchange.com/a/6348
SETUP='\
if [ -f /etc/os-release ]; then \
	. /etc/os-release; \
	OS=$$NAME; \
	VER=$$VERSION_ID; \
fi;\
if [ "$$OS" == "Pop!_OS" ]; then \
	sudo apt install -y build-essential automake pkg-config cmake \
		libncurses5-dev zlib1g-dev libssl-dev python-openssl libffi-dev; \
fi;\
'

ENV_PRETTY='\
export PYENV_ROOT=${PWD}/pyenv/;\n\
export PATH=$$PYENV_ROOT/bin:${PWD}/bin:$$PATH;\n\
if command -v pyenv 1>/dev/null 2>&1; then\n\
\teval "$$(pyenv init -)";\n\
\teval "$$(pyenv virtualenv-init -)";\n\
fi;\n\
'
ENV=$(subst \n, , $(subst \t, , ${ENV_PRETTY}))

all: nvim 

nvim: setup ${NVIM}
${NVIM}: pyenv fzy ctags 
	wget "https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage" -O "${PWD}/bin/nvim"
	chmod u+x ${PWD}/bin/nvim
	wget "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "config/nvim/autoload/plug.vim"
	wget "https://raw.githubusercontent.com/AlessandroYorba/Despacio/master/colors/despacio.vim" -O "config/nvim/colors/despacio.vim"
	@${SHELL} -c ${ENV}' PYENV_VERSION=nvim-provider XDG_CONFIG_HOME=${PWD}/config ${PWD}/bin/nvim +PlugInstall'

pyenv: ${PYENV}
${PYENV}:
	@git clone https://github.com/pyenv/pyenv.git ${PWD}/pyenv
	@git clone https://github.com/pyenv/pyenv-virtualenv.git ${PWD}/pyenv/plugins/pyenv-virtualenv
	@${SHELL} -c ${ENV}'pyenv install 3.7.2; pyenv virtualenv 3.7.2 nvim-provider; pyenv activate nvim-provider; pip install --upgrade pip neovim-remote;'

fzy: ${FZY}
${FZY}: 
	@git clone https://github.com/jhawthorn/fzy.git repositories/fzy
	@cd repositories/fzy && make && make PREFIX=${PWD} install

ctags: ${CTAGS}
${CTAGS}:
	@git clone https://github.com/universal-ctags/ctags.git repositories/ctags
	@cd repositories/ctags/ && ./autogen.sh && ./configure --prefix=${PWD} && make && make install

env:
	@printf '###################################### DEVTOOLS #######################################\n'
	@printf ${ENV_PRETTY}
	@printf 'alias n="PYENV_VERSION=nvim-provider XDG_CONFIG_HOME=${PWD}/config nvim"\n'
	@printf '#######################################################################################\n'

setup:
	mkdir -p ${PWD}/repositories
	mkdir -p ${PWD}/bin
	mkdir -p ${PWD}/lib
	mkdir -p ${PWD}/lib64
	mkdir -p ${PWD}/share
	@echo "Check for dependencies..."
	@${SHELL} -c ${SETUP}

clean:
	rm -rf repositories/*
	rm -rf bin/* lib/* lib64/* share/* include/*
	rm -rf pyenv/
	rm -rf config/nvim/plugins/*
	rm -rf config/nvim/autoload/*
	rm -rf config/nvim/colors/*
