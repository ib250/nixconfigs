
function for_vim() {
    rm -rf ${HOME}/.vim
    cp -f $(pwd)/minimal.vim ${HOME}/.vimrc
}


function for_nvim() {
    cp -f $(pwd)/minimal.vim ${XDG_CONFIG_DIR}/nvim/init.vim
}

USAGE="
$0 target
where target = --vim | --nvim
"

case ${1} in
    --vim ) for_vim;;
    --nvim ) for_nvim;;
    * | --help | -h ) echo "${USAGE}";;
esac
