
function for_vim() {
    rm -rf ${HOME}/.vim
    rm -rf ${HOME}/.config/coc
    cp -f $(pwd)/minimal.vim ${HOME}/.vimrc
}


function for_nvim() {
    rm -rf ${HOME}/.config/coc
    rm -rf ${HOME}/.config/nvim
    mkdir -p ${HOME}/.config/nvim
    rm -rf ~/.local/share/nvim
    cp -f $(pwd)/minimal.vim ${HOME}/.config/nvim/init.vim
}


function _coc_config() {
    case ${1} in
        --vim ) echo "${HOME}/.vim/coc-settings.json";;
        --nvim ) echo "${HOME}/.config/nvim/coc-settings.json";;
    esac
}


function coc_basics() {
    cbs="CocInstall coc-json coc-yaml coc-python coc-tsserver coc-marketplace coc-vimlsp"
    case ${1} in
        --vim ) vim -c "${cbs}";;
        --nvim ) nvim -c "${cbs}";;
    esac
}


function coc_clangd() {
    which clangd && {

        $(pwd)/coc_with_config.js "$(_coc_config ${1})" "$(which clangd)" "clangd"

    } || echo "clangd is required for this"
}


function coc_scala_metals() {
    which metals-vim && {
        $(pwd)/coc_with_config.js "$(_coc_config ${1})" "$(which metals-vim)" "metals"
    } || echo "metals-vim is required for this"
}


case ${1} in
    --vim ) shift && for_vim $*;;
    --nvim ) shift && for_nvim $*;;
    * | --help | -h ) echo "

$0 target [ options ]
where target = --vim | --nvim

alternatively i am keeping a few functions here for post_install
to use, source $0 and run as required

coc_basics [ --vim | --nvim ]       -- install some basic stuff through coc package management
coc_clangd [ --vim | --nvim ]       -- include clangd language server
coc_scala_metals [ --vim | --nvim ] -- include scala metals for scala language server

"

esac
