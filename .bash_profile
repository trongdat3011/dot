export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home
export EDITOR=vim
# added by Anaconda2 4.4.0 installer
export PATH="/Users/admin/anaconda/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"

# Colorful terminal
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# quick location
alias ls='ls -GFh'
alias cc="cd ~/Projects/coccoc/"

# Auto complete git command
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# added by Rails
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Useful shortcuts
g11 () {
    filename=$(basename "$1")
    filename="${filename%.*}"
    g++ -O2 --std=c++11 "$1" && ./a.out
    # printf "\n"
}

solve () {
    cp -n ~/Competitive/template.cpp ./"$1".cpp
    code ./"$1".cpp
}

compare_py_c++ () {
    time python "$1.py" < input.txt > output-py.txt
    time g11 "$1.cpp" < input.txt > output-cpp.txt
    printf "\n"
    echo "Diff between"
    diff output-py.txt output-cpp.txt
}

rnton () {
    perl -pi -e 's/\r\n|\n|\r/\n/g' $1
}

r_cron_log () {
    printf '%100s\n' | tr ' ' -
    cat "$1" | grep -v sh
}

enter_env () {
    source ./env/bin/activate
}

# Function to sync local works to remote
# remote_sync file1 file2 ...
# Need 2 environment variables to work: FAST_SYNC_DESTINATION_ROOT_FOLDER and FAST_SYNC_LOCAL_ROOT_FOLDER
remote_sync () {
    if [ -z $FAST_SYNC_DESTINATION_ROOT_FOLDER ] || [ -z $FAST_SYNC_LOCAL_ROOT_FOLDER ]; then
        echo "FAST_SYNC_DESTINATION_ROOT_FOLDER OR FAST_SYNC_LOCAL_ROOT_FOLDER WAS NOT SET"
        return 1;
    fi
    # the first element when using with sync_all_modified is always .gitignore, i ignore it
    if [ "$#" -gt 1 ]; then
        shift;
    fi
    for file_name in "$@"
    do
        full_path=$(greadlink -f ${file_name})
        relative_path=$(realpath --relative-to=${FAST_SYNC_LOCAL_ROOT_FOLDER} ${full_path})
        echo "Syncing ${relative_path}"
        echo "Destination directory: ${FAST_SYNC_DESTINATION_ROOT_FOLDER}"
        # echo "Destination path: ${FAST_SYNC_DESTINATION_ROOT_FOLDER}${relative_path}"
        scp -r $full_path ${FAST_SYNC_DESTINATION_ROOT_FOLDER}${relative_path}
    done
    echo "Syncing complete, please learn rsync"
}

# Simply get all modified file and pass them to remote_sync()
# TODO: get all file currently in different state compare with remote
sync_all_modified () {
    modified_files=$(git status -s | grep M | awk '{print $2}' | xargs)
    remote_sync ${modified_files}
}

msh () {
    rsync --inplace -q  $HOME/.ssh/config $@:/home/trongdat/.ssh/config
    rsync --inplace -q $HOME/.vimrc $@:/home/trongdat/.vimrc
    rsync --inplace -q  $HOME/.dircolors $@:/home/trongdat/.dircolors
    ssh $@
}
alias ssh='msh'

PS1="[\D{%T}]$PS1"
