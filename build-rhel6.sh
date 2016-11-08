#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Introduction: https://github.com/vbem/man-to-github-pages

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# global configs

declare SUBPATH=$1
declare -i IS_DEBUG=1
declare PATH_THIS=$(realpath ${BASH_SOURCE[0]})
declare DIR_THIS=$(dirname $PATH_THIS)
declare BASE_THIS=$(basename $PATH_THIS)
declare DIR_MAN=$SUBPATH/man
declare PATH_INDEX=$SUBPATH/index.html

mkdir -p $SUBPATH

declare INDEX_BEGIN='
<html>
<head><title>Man Pages on Github Pages</title></head>
<body bgcolor="white">
<h1><a href="https://github.com/vbem/man-to-github-pages" target="_blank">Man Pages on Github Pages</a></h1>
Use CTRL+F for searching.<br /> 
For more, check <a href="http://man7.org/linux/man-pages/index.html" target="_blank">man7.org</a> and <a href="http://linux.die.net/man/" target="_blank">die.net</a>.
<hr><table border="1">
<tr><td>Section</td><td>Name</td><td>Description</td></tr>
'

declare INDEX_END='
</table><hr></body>
</html>
'

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# common functions

function echoDebug
# echo debug message
#   $1: debug level
#   $2: message string
{
    if [ 1 -eq ${IS_DEBUG} ]; then
        echo -e "\e[45m[$$ $0 $(date +'%F %T') $1]\e[m $2" >&2
    fi
}

function echoError
{
    if [ 1 -eq ${IS_DEBUG} ]; then
        echo -e "\e[31m[$$ $0 $(date +'%F %T') $1]\e[m $2" >&2
    fi
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# process functions

function convertAll
{
    declare sDirOutput=$1
    echo $INDEX_BEGIN > $PATH_INDEX
    apropos . | while read sLine; do
        declare sName=$(echo $sLine | cut -d' ' -f1)
        declare sSection=$(echo $sLine | cut -d')' -f1|cut -d'(' -f2)
        declare sDescription=$(echo $sLine | cut -d')' -f2|cut -d'-' -f2)
        declare sPathHtml=$DIR_MAN/${sSection}_${sName}.html
        if [ -f sPathHtml ]; then
            echoError ERROR "Skip '${sSection}' '${sName}' due to duplicated"
            continue
        fi
        man -P cat ${sSection} ${sName} > /dev/null
        if [ $? -ne 0 ]; then
            echoError ERROR "Skip '${sSection}' '${sName}' due to non-exist"
            continue
        fi
        echoDebug DEBUG "generating '$sLine' to '$sPathHtml' ...."

        man -P cat ${sSection} ${sName}|groff -mandoc -Thtml > $sPathHtml
        echo "<tr><td>$sSection</td><td><a href='$sPathHtml' target='_blank'>$sName</a></td><td>$sDescription</td></tr>" >> $PATH_INDEX
    done
    echo $INDEX_END >> $PATH_INDEX
    return $?
}

function main
{
    convertAll
    return $?
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
main $@
exit $?
