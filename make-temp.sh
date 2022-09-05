function makeTemp() {
    [ -n $TMP ] || TMP='/tmp'

    local type_name=$1
    local prefix=${2:-$TMP/temp}
    local temp_type=''
    local sanity_check=''
    
    case $type_name in
        file )
            temp_type=''
            ur_cmd='touch'
            sanity_check='test -f $TEMP_NAME -a -r $TEMP_NAME -a -w $TEMP_NAME -a -O $TEMP_NAME';;
        dir|directory )
            temp_type='-d'
            ur_cmd='mkdir -p -m0700'
            sanity_check='test -d $TEMP_NAME -a -r $TEMP_NAME -a -w $TEMP_NAME -a -x $TEMP_NAME -a -O $TEMP_NAME';;
       *) Error "\nBad type in $PROGRAM:make-tem! Needs file|dir." 1;;
    esac
        
    TEMP_NAME=$(mktemp $temp_type ${prefix}.XXXXXXXXX)
    if [ -z "$TEMP_NAME" ]
    then
         TEMP_NAME="${prefix}.$(cat /dev/urandom | od -x | tr -d ' ' | head -1)"
         $ur_cmd $TEMP_NAME
    fi     
    if ! eval $sanity_check
    then
        Error "\aFATAL ERROR: can't create temp $type_name with '$0:MakeTemp$*'!\n" 2
    else
        echo "$TEMP_NAME"
    fi
}

