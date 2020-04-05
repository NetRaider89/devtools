SHELL:=/bin/bash

PYENV=${PWD}/pyenv/bin/pyenv
NVM=${PWD}/nvm/nvm.sh
NVIM=${PWD}/nvim-linux64/bin/nvim

PYTHON3_VERSION=3.7.2
NODE_VERSION=v12.16.1

PYTHON3_BIN=${PWD}/pyenv/versions/nvim-provider/bin/python3

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
	sudo apt build-dep -y python3.7; \
fi;\
'

ENV_PRETTY='\
export PYENV_ROOT=${PWD}/pyenv/;\n\
export PATH=$$PYENV_ROOT/bin:${PWD}/nvim-linux64/bin:$$PATH;\n\
if command -v pyenv 1>/dev/null 2>&1; then\n\
\teval "$$(pyenv init -)";\n\
\teval "$$(pyenv virtualenv-init -)";\n\
fi;\n\
'

ENV=$(subst \n, , $(subst \t, , ${ENV_PRETTY}))

all: nvim 

nvim: setup pyenv nvm python ${NVIM}
${NVIM}: 
	wget -qO- "https://github.com/neovim/neovim/releases/download/v0.4.3/nvim-linux64.tar.gz" | tar xz
	chmod u+x ${NVIM}
	wget "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O "config/nvim/autoload/plug.vim"
	wget "https://raw.githubusercontent.com/AlessandroYorba/Despacio/master/colors/despacio.vim" -O "config/nvim/colors/despacio.vim"
	@${SHELL} -c ${ENV}' PYENV_VERSION=nvim-provider XDG_CONFIG_HOME=${PWD}/config ${NVIM} +PlugInstall'

pyenv: ${PYENV}
${PYENV}:
	@git clone https://github.com/pyenv/pyenv.git ${PWD}/pyenv
	@git clone https://github.com/pyenv/pyenv-virtualenv.git ${PWD}/pyenv/plugins/pyenv-virtualenv

python: ${PYTHON3_BIN}
${PYTHON3_BIN}:
	@${SHELL} -c ${ENV}'pyenv install -s ${PYTHON3_VERSION} && pyenv virtualenv -f ${PYTHON3_VERSION} nvim-provider && pyenv activate nvim-provider && pip install --upgrade pip neovim-remote'
	PYTHON3_PATH=$$( ${SHELL} -c ${ENV}' PYENV_VERSION=nvim-provider pyenv which python3' ) && sed -i "/python3_host_prog/c\let g:python3_host_prog=\"$$PYTHON3_PATH\"" ${PWD}/config/nvim/init.vim

setup:
	mkdir -p ${PWD}/config/nvim/autoload
	mkdir -p ${PWD}/config/nvim/colors
	@echo "Check for dependencies..."
	@${SHELL} -c ${SETUP}

nvm: ${NVM}
${NVM}:
	@git clone https://github.com/nvm-sh/nvm.git ${PWD}/nvm && cd ${PWD}/nvm && git checkout v0.35.3
	@source ${PWD}/nvm/nvm.sh && nvm install v12.16.1 && nvm use v12.16.1
	sed -i "/node_host_prog/c\let g:node_host_prog=\"${PWD}/nvm/versions/node/${NODE_VERSION}/bin/neovim-node-host\"" ${PWD}/config/nvim/init.vim
env:
	@printf '###################################### DEVTOOLS #######################################\n'
	@printf ${ENV_PRETTY}
	@printf 'source ${PWD}/nvm/nvm.sh\n'
	@printf 'alias n="PYENV_VERSION=nvim-provider XDG_CONFIG_HOME=${PWD}/config nvim"\n'
	@printf '#######################################################################################\n'

clean:
	rm -rf pyenv/
	rm -rf nvm/
	rm -rf nvim-linux64/
	rm -rf config/nvim/plugins/*
	rm -rf config/nvim/autoload/*
	rm -rf config/nvim/colors/*
