function __print_xtended_functions_help() {
cat <<EOF
Additional MSM-Xtended functions:
- cout:            Changes directory to out.
- mmp:             Builds all of the modules in the current directory and pushes them to the device.
- mmap:            Builds all of the modules in the current directory and its dependencies, then pushes the package to the device.
- mmmp:            Builds all of the modules in the supplied directories and pushes them to the device.
- xtendedgerrit:   A Git wrapper that fetches/pushes patch from/to MSM-Xtended Gerrit Review.
- xtendedrebase:   Rebase a Gerrit change and push it again.
- xtendedremote:   Add git remote for MSM-Xtended Gerrit Review.
- aospremote:      Add git remote for matching AOSP repository.
- cafremote:       Add git remote for matching CodeAurora repository.
- githubremote:    Add git remote for Project-Xtended Github.
- mka:             Builds using SCHED_BATCH on all processors.
- mkap:            Builds the module(s) using mka and pushes them to the device.
- cmka:            Cleans and builds using mka.
- repodiff:        Diff 2 different branches or tags within the same repo
- repolastsync:    Prints date and time of last repo sync.
- reposync:        Parallel repo sync using ionice and SCHED_BATCH.
- repopick:        Utility to fetch changes from Gerrit.
EOF
}

function mk_timer()
{
    local start_time=$(date +"%s")
    $@
    local ret=$?
    local end_time=$(date +"%s")
    local tdiff=$(($end_time-$start_time))
    local hours=$(($tdiff / 3600 ))
    local mins=$((($tdiff % 3600) / 60))
    local secs=$(($tdiff % 60))
    local ncolors=$(tput colors 2>/dev/null)
    echo
    if [ $ret -eq 0 ] ; then
        echo -n "#### make completed successfully "
    else
        echo -n "#### make failed to build some targets "
    fi
    if [ $hours -gt 0 ] ; then
        printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs
    elif [ $mins -gt 0 ] ; then
        printf "(%02g:%02g (mm:ss))" $mins $secs
    elif [ $secs -gt 0 ] ; then
        printf "(%s seconds)" $secs
    fi
    echo " ####"
    echo
    return $ret
}

function brunch()
{
    breakfast $*
    if [ $? -eq 0 ]; then
        mka xtended
    else
        echo "No such item in brunch menu. Try 'breakfast'"
        return 1
    fi
    return $?
}

function breakfast()
{
    target=$1
    local variant=$2

    if [ $# -eq 0 ]; then
        # No arguments, so let's have the full menu
        lunch
    else
        if [[ "$target" =~ -(user|userdebug|eng)$ ]]; then
            # A buildtype was specified, assume a full device name
            lunch $target
        else
            # This is probably just the Xtended model name
            if [ -z "$variant" ]; then
                variant="userdebug"
            fi

            lunch xtended_$target-$variant
        fi
    fi
    return $?
}

alias bib=breakfast

function omnom()
{
    brunch $*
    eat
}

function cout()
{
    if [  "$OUT" ]; then
        cd $OUT
    else
        echo "Couldn't locate out directory.  Try setting OUT."
    fi
}

function dddclient()
{
   local OUT_ROOT=$(get_abs_build_var PRODUCT_OUT)
   local OUT_SYMBOLS=$(get_abs_build_var TARGET_OUT_UNSTRIPPED)
   local OUT_SO_SYMBOLS=$(get_abs_build_var TARGET_OUT_SHARED_LIBRARIES_UNSTRIPPED)
   local OUT_VENDOR_SO_SYMBOLS=$(get_abs_build_var TARGET_OUT_VENDOR_SHARED_LIBRARIES_UNSTRIPPED)
   local OUT_EXE_SYMBOLS=$(get_symbols_directory)
   local PREBUILTS=$(get_abs_build_var ANDROID_PREBUILTS)
   local ARCH=$(get_build_var TARGET_ARCH)
   local GDB
   case "$ARCH" in
       arm) GDB=arm-linux-androideabi-gdb;;
       arm64) GDB=arm-linux-androideabi-gdb; GDB64=aarch64-linux-android-gdb;;
       mips|mips64) GDB=mips64el-linux-android-gdb;;
       x86) GDB=x86_64-linux-android-gdb;;
       x86_64) GDB=x86_64-linux-android-gdb;;
       *) echo "Unknown arch $ARCH"; return 1;;
   esac

   if [ "$OUT_ROOT" -a "$PREBUILTS" ]; then
       local EXE="$1"
       if [ "$EXE" ] ; then
           EXE=$1
           if [[ $EXE =~ ^[^/].* ]] ; then
               EXE="system/bin/"$EXE
           fi
       else
           EXE="app_process"
       fi

       local PORT="$2"
       if [ "$PORT" ] ; then
           PORT=$2
       else
           PORT=":5039"
       fi

       local PID="$3"
       if [ "$PID" ] ; then
           if [[ ! "$PID" =~ ^[0-9]+$ ]] ; then
               PID=`pid $3`
               if [[ ! "$PID" =~ ^[0-9]+$ ]] ; then
                   # that likely didn't work because of returning multiple processes
                   # try again, filtering by root processes (don't contain colon)
                   PID=`adb shell ps | \grep $3 | \grep -v ":" | awk '{print $2}'`
                   if [[ ! "$PID" =~ ^[0-9]+$ ]]
                   then
                       echo "Couldn't resolve '$3' to single PID"
                       return 1
                   else
                       echo ""
                       echo "WARNING: multiple processes matching '$3' observed, using root process"
                       echo ""
                   fi
               fi
           fi
           adb forward "tcp$PORT" "tcp$PORT"
           local USE64BIT="$(is64bit $PID)"
           adb shell gdbserver$USE64BIT $PORT --attach $PID &
           sleep 2
       else
               echo ""
               echo "If you haven't done so already, do this first on the device:"
               echo "    gdbserver $PORT /system/bin/$EXE"
                   echo " or"
               echo "    gdbserver $PORT --attach <PID>"
               echo ""
       fi

       OUT_SO_SYMBOLS=$OUT_SO_SYMBOLS$USE64BIT
       OUT_VENDOR_SO_SYMBOLS=$OUT_VENDOR_SO_SYMBOLS$USE64BIT

       echo >|"$OUT_ROOT/gdbclient.cmds" "set solib-absolute-prefix $OUT_SYMBOLS"
       echo >>"$OUT_ROOT/gdbclient.cmds" "set solib-search-path $OUT_SO_SYMBOLS:$OUT_SO_SYMBOLS/hw:$OUT_SO_SYMBOLS/ssl/engines:$OUT_SO_SYMBOLS/drm:$OUT_SO_SYMBOLS/egl:$OUT_SO_SYMBOLS/soundfx:$OUT_VENDOR_SO_SYMBOLS:$OUT_VENDOR_SO_SYMBOLS/hw:$OUT_VENDOR_SO_SYMBOLS/egl"
       echo >>"$OUT_ROOT/gdbclient.cmds" "source $ANDROID_BUILD_TOP/development/scripts/gdb/dalvik.gdb"
       echo >>"$OUT_ROOT/gdbclient.cmds" "target remote $PORT"
       # Enable special debugging for ART processes.
       if [[ $EXE =~ (^|/)(app_process|dalvikvm)(|32|64)$ ]]; then
          echo >> "$OUT_ROOT/gdbclient.cmds" "art-on"
       fi
       echo >>"$OUT_ROOT/gdbclient.cmds" ""

       local WHICH_GDB=
       # 64-bit exe found
       if [ "$USE64BIT" != "" ] ; then
           WHICH_GDB=$ANDROID_TOOLCHAIN/$GDB64
       # 32-bit exe / 32-bit platform
       elif [ "$(get_build_var TARGET_2ND_ARCH)" = "" ]; then
           WHICH_GDB=$ANDROID_TOOLCHAIN/$GDB
       # 32-bit exe / 64-bit platform
       else
           WHICH_GDB=$ANDROID_TOOLCHAIN_2ND_ARCH/$GDB
       fi

       ddd --debugger $WHICH_GDB -x "$OUT_ROOT/gdbclient.cmds" "$OUT_EXE_SYMBOLS/$EXE"
  else
       echo "Unable to determine build system output dir."
   fi
}

function xtendedremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm xtended 2> /dev/null
    local REMOTE=$(git config --get remote.github.projectname)
    local XTENDED="true"
    if [ -z "$REMOTE" ]
    then
        REMOTE=$(git config --get remote.aosp.projectname)
        XTENDED="false"
    fi
    if [ -z "$REMOTE" ]
    then
        REMOTE=$(git config --get remote.caf.projectname)
        XTENDED="false"
    fi

    if [ $XTENDED = "false" ]
    then
        local PROJECT=$(echo $REMOTE | sed -e "s#platform/#android/#g; s#/#_#g")
        local PFX="MSM-Xtended/"
    else
        local PROJECT=$REMOTE
    fi

    local XTENDED_USER=$(git config --get review.review.msmxtended.org.username)
    if [ -z "$XTENDED_USER" ]
    then
        git remote add xtended ssh://review.msmxtended.org:29418/$PFX$PROJECT
    else
        git remote add xtended ssh://$XTENDED_USER@review.msmxtended.org:29418/$PFX$PROJECT
    fi
    echo "Remote 'xtended' created"
}

function aospremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm aosp 2> /dev/null
    local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##")
    # Google moved the repo location in Oreo
    if [ $PROJECT = "build/make" ]
    then
        PROJECT="build"
    fi
    if (echo $PROJECT | grep -qv "^device")
    then
        local PFX="platform/"
    fi
    git remote add aosp https://android.googlesource.com/$PFX$PROJECT
    echo "Remote 'aosp' created"
}

function githubremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm github 2> /dev/null
    local REMOTE=$(git config --get remote.aosp.projectname)

    if [ -z "$REMOTE" ]
    then
        REMOTE=$(git config --get remote.caf.projectname)
    fi

    local PROJECT=$(echo $REMOTE | sed -e "s#platform/#android/#g; s#/#_#g")

    git remote add github https://github.com/Project-Xtended/$PROJECT
    echo "Remote 'github' created"
}

function cafremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm caf 2> /dev/null
    local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##")
     # Google moved the repo location in Oreo
    if [ $PROJECT = "build/make" ]
    then
        PROJECT="build"
    fi
    if [[ $PROJECT =~ "qcom/opensource" ]];
    then
        PROJECT=$(echo $PROJECT | sed -e "s#qcom\/opensource#qcom-opensource#")
    fi
    if (echo $PROJECT | grep -qv "^device")
    then
        local PFX="platform/"
    fi
    git remote add caf https://source.codeaurora.org/quic/la/$PFX$PROJECT
    echo "Remote 'caf' created"
}

function makerecipe() {
    if [ -z "$1" ]
    then
        echo "No branch name provided."
        return 1
    fi
    cd android
    sed -i s/'default revision=.*'/'default revision="refs\/heads\/'$1'"'/ default.xml
    git commit -a -m "$1"
    cd ..

    repo forall -c '

    if [ "$REPO_REMOTE" = "github" ]
    then
        pwd
        xtendedremote
        git push xtended HEAD:refs/heads/'$1'
    fi
    '
}

function xtendedgerrit() {
    if [ "$(basename $SHELL)" = "zsh" ]; then
        # zsh does not define FUNCNAME, derive from funcstack
        local FUNCNAME=$funcstack[1]
    fi

    if [ $# -eq 0 ]; then
        $FUNCNAME help
        return 1
    fi
    local user=`git config --get review.review.msmxteded.org.username`
    local review=`git config --get remote.github.review`
    local project=`git config --get remote.github.projectname`
    local command=$1
    shift
    case $command in
        help)
            if [ $# -eq 0 ]; then
                cat <<EOF
Usage:
    $FUNCNAME COMMAND [OPTIONS] [CHANGE-ID[/PATCH-SET]][{@|^|~|:}ARG] [-- ARGS]

Commands:
    fetch   Just fetch the change as FETCH_HEAD
    help    Show this help, or for a specific command
    pull    Pull a change into current branch
    push    Push HEAD or a local branch to Gerrit for a specific branch

Any other Git commands that support refname would work as:
    git fetch URL CHANGE && git COMMAND OPTIONS FETCH_HEAD{@|^|~|:}ARG -- ARGS

See '$FUNCNAME help COMMAND' for more information on a specific command.

Example:
    $FUNCNAME checkout -b topic 1234/5
works as:
    git fetch http://DOMAIN/p/PROJECT refs/changes/34/1234/5 \\
      && git checkout -b topic FETCH_HEAD
will checkout a new branch 'topic' base on patch-set 5 of change 1234.
Patch-set 1 will be fetched if omitted.
EOF
                return
            fi
            case $1 in
                __cmg_*) echo "For internal use only." ;;
                changes|for)
                    if [ "$FUNCNAME" = "xtendedgerrit" ]; then
                        echo "'$FUNCNAME $1' is deprecated."
                    fi
                    ;;
                help) $FUNCNAME help ;;
                fetch|pull) cat <<EOF
usage: $FUNCNAME $1 [OPTIONS] CHANGE-ID[/PATCH-SET]

works as:
    git $1 OPTIONS http://DOMAIN/p/PROJECT \\
      refs/changes/HASH/CHANGE-ID/{PATCH-SET|1}

Example:
    $FUNCNAME $1 1234
will $1 patch-set 1 of change 1234
EOF
                    ;;
                push) cat <<EOF
usage: $FUNCNAME push [OPTIONS] [LOCAL_BRANCH:]REMOTE_BRANCH

works as:
    git push OPTIONS ssh://USER@DOMAIN:29418/PROJECT \\
      {LOCAL_BRANCH|HEAD}:refs/for/REMOTE_BRANCH

Example:
    $FUNCNAME push fix6789:gingerbread
will push local branch 'fix6789' to Gerrit for branch 'gingerbread'.
HEAD will be pushed from local if omitted.
EOF
                    ;;
                *)
                    $FUNCNAME __cmg_err_not_supported $1 && return
                    cat <<EOF
usage: $FUNCNAME $1 [OPTIONS] CHANGE-ID[/PATCH-SET][{@|^|~|:}ARG] [-- ARGS]

works as:
    git fetch http://DOMAIN/p/PROJECT \\
      refs/changes/HASH/CHANGE-ID/{PATCH-SET|1} \\
      && git $1 OPTIONS FETCH_HEAD{@|^|~|:}ARG -- ARGS
EOF
                    ;;
            esac
            ;;
        __cmg_get_ref)
            $FUNCNAME __cmg_err_no_arg $command $# && return 1
            local change_id patchset_id hash
            case $1 in
                */*)
                    change_id=${1%%/*}
                    patchset_id=${1#*/}
                    ;;
                *)
                    change_id=$1
                    patchset_id=1
                    ;;
            esac
            hash=$(($change_id % 100))
            case $hash in
                [0-9]) hash="0$hash" ;;
            esac
            echo "refs/changes/$hash/$change_id/$patchset_id"
            ;;
        fetch|pull)
            $FUNCNAME __cmg_err_no_arg $command $# help && return 1
            $FUNCNAME __cmg_err_not_repo && return 1
            local change=$1
            shift
            git $command $@ http://$review/p/$project \
                $($FUNCNAME __cmg_get_ref $change) || return 1
            ;;
        push)
            $FUNCNAME __cmg_err_no_arg $command $# help && return 1
            $FUNCNAME __cmg_err_not_repo && return 1
            if [ -z "$user" ]; then
                echo >&2 "Gerrit username not found."
                return 1
            fi
            local local_branch remote_branch
            case $1 in
                *:*)
                    local_branch=${1%:*}
                    remote_branch=${1##*:}
                    ;;
                *)
                    local_branch=HEAD
                    remote_branch=$1
                    ;;
            esac
            shift
            git push $@ ssh://$user@$review:29418/$project \
                ${local_branch}:refs/for/$remote_branch || return 1
            ;;
        changes|for)
            if [ "$FUNCNAME" = "xtendedgerrit" ]; then
                echo >&2 "'$FUNCNAME $command' is deprecated."
            fi
            ;;
        __cmg_err_no_arg)
            if [ $# -lt 2 ]; then
                echo >&2 "'$FUNCNAME $command' missing argument."
            elif [ $2 -eq 0 ]; then
                if [ -n "$3" ]; then
                    $FUNCNAME help $1
                else
                    echo >&2 "'$FUNCNAME $1' missing argument."
                fi
            else
                return 1
            fi
            ;;
        __cmg_err_not_repo)
            if [ -z "$review" -o -z "$project" ]; then
                echo >&2 "Not currently in any reviewable repository."
            else
                return 1
            fi
            ;;
        __cmg_err_not_supported)
            $FUNCNAME __cmg_err_no_arg $command $# && return
            case $1 in
                #TODO: filter more git commands that don't use refname
                init|add|rm|mv|status|clone|remote|bisect|config|stash)
                    echo >&2 "'$FUNCNAME $1' is not supported."
                    ;;
                *) return 1 ;;
            esac
            ;;
    #TODO: other special cases?
        *)
            $FUNCNAME __cmg_err_not_supported $command && return 1
            $FUNCNAME __cmg_err_no_arg $command $# help && return 1
            $FUNCNAME __cmg_err_not_repo && return 1
            local args="$@"
            local change pre_args refs_arg post_args
            case "$args" in
                *--\ *)
                    pre_args=${args%%-- *}
                    post_args="-- ${args#*-- }"
                    ;;
                *) pre_args="$args" ;;
            esac
            args=($pre_args)
            pre_args=
            if [ ${#args[@]} -gt 0 ]; then
                change=${args[${#args[@]}-1]}
            fi
            if [ ${#args[@]} -gt 1 ]; then
                pre_args=${args[0]}
                for ((i=1; i<${#args[@]}-1; i++)); do
                    pre_args="$pre_args ${args[$i]}"
                done
            fi
            while ((1)); do
                case $change in
                    ""|--)
                        $FUNCNAME help $command
                        return 1
                        ;;
                    *@*)
                        if [ -z "$refs_arg" ]; then
                            refs_arg="@${change#*@}"
                            change=${change%%@*}
                        fi
                        ;;
                    *~*)
                        if [ -z "$refs_arg" ]; then
                            refs_arg="~${change#*~}"
                            change=${change%%~*}
                        fi
                        ;;
                    *^*)
                        if [ -z "$refs_arg" ]; then
                            refs_arg="^${change#*^}"
                            change=${change%%^*}
                        fi
                        ;;
                    *:*)
                        if [ -z "$refs_arg" ]; then
                            refs_arg=":${change#*:}"
                            change=${change%%:*}
                        fi
                        ;;
                    *) break ;;
                esac
            done
            $FUNCNAME fetch $change \
                && git $command $pre_args FETCH_HEAD$refs_arg $post_args \
                || return 1
            ;;
    esac
}

function xtendedrebase() {
    local repo=$1
    local refs=$2
    local pwd="$(pwd)"
    local dir="$(gettop)/$repo"

    if [ -z $repo ] || [ -z $refs ]; then
        echo "MSM-Xtended Gerrit Rebase Usage: "
        echo "      xtendedrebase <path to project> <patch IDs on Gerrit>"
        echo "      The patch IDs appear on the Gerrit commands that are offered."
        echo "      They consist on a series of numbers and slashes, after the text"
        echo "      refs/changes. For example, the ID in the following command is 26/8126/2"
        echo ""
        echo "      git[...]ges_apps_Camera refs/changes/26/8126/2 && git cherry-pick FETCH_HEAD"
        echo ""
        return
    fi

    if [ ! -d $dir ]; then
        echo "Directory $dir doesn't exist in tree."
        return
    fi
    cd $dir
    repo=$(cat .git/config  | grep git://github.com | awk '{ print $NF }' | sed s#git://github.com/##g)
    echo "Starting branch..."
    repo start tmprebase .
    echo "Bringing it up to date..."
    repo sync .
    echo "Fetching change..."
    git fetch "http://review.msmxtended.org/p/$repo" "refs/changes/$refs" && git cherry-pick FETCH_HEAD
    if [ "$?" != "0" ]; then
        echo "Error cherry-picking. Not uploading!"
        return
    fi
    echo "Uploading..."
    repo upload .
    echo "Cleaning up..."
    repo abandon tmprebase .
    cd $pwd
}

function mka() {
    if [ "$1" = "signed-zip" ]; then
        if m -j target-files-package otatools; then
            croot
            source vendor/xtended/scripts/sign.sh
            source vendor/xtended/scripts/update.sh
        fi
    else
        m -j "$@"
    fi
}

function cmka() {
    if [ ! -z "$1" ]; then
        for i in "$@"; do
            case $i in
                xtended|otapackage|bacon|systemimage)
                    mka installclean
                    mka $i
                    ;;
                *)
                    mka clean-$i
                    mka $i
                    ;;
            esac
        done
    else
        mka clean
        mka
    fi
}

function repolastsync() {
    RLSPATH="$ANDROID_BUILD_TOP/.repo/.repo_fetchtimes.json"
    RLSLOCAL=$(date -d "$(stat -c %z $RLSPATH)" +"%e %b %Y, %T %Z")
    RLSUTC=$(date -d "$(stat -c %z $RLSPATH)" -u +"%e %b %Y, %T %Z")
    echo "Last repo sync: $RLSLOCAL / $RLSUTC"
}

function reposync() {
    repo sync -j 4 "$@"
}

function repodiff() {
    if [ -z "$*" ]; then
        echo "Usage: repodiff <ref-from> [[ref-to] [--numstat]]"
        return
    fi
    diffopts=$* repo forall -c \
      'echo "$REPO_PATH ($REPO_REMOTE)"; git diff ${diffopts} 2>/dev/null ;'
}

alias mmp='dopush mm'
alias mmmp='dopush mmm'
alias mmap='dopush mma'
alias mmmap='dopush mmma'
alias mkap='dopush mka'
alias cmkap='dopush cmka'

function repopick() {
    T=$(gettop)
    $T/vendor/xtended/build/tools/repopick.py $@
}

function fixup_common_out_dir() {
    common_out_dir=$(get_build_var OUT_DIR)/target/common
    target_device=$(get_build_var TARGET_DEVICE)
    common_target_out=common-${target_device}
    if [ ! -z $XTENDED_FIXUP_COMMON_OUT ]; then
        if [ -d ${common_out_dir} ] && [ ! -L ${common_out_dir} ]; then
            mv ${common_out_dir} ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        else
            [ -L ${common_out_dir} ] && rm ${common_out_dir}
            mkdir -p ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        fi
    else
        [ -L ${common_out_dir} ] && rm ${common_out_dir}
        mkdir -p ${common_out_dir}
    fi
}

# Disable ABI checking
export SKIP_ABI_CHECKS=true
