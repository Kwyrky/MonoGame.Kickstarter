#! /bin/bash

version="1.01"

################################################################################
# COMMAND LINE OPTIONS
################################################################################

# saner programming env: these switches turn some bugs into errors
#set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=hn:dsvaoiuxw
LONGOPTS=help,name:,debug,solution,verbose,mgandroid,mgdesktopgl,mgios,mguwpcore,mguwpxaml,mgwindowsdx

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# set defaults
h=n
n=monogamekickstarter
#
d=y
s=y
v=y
#
a=n
o=y
i=n
u=n
x=n
w=n

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            h=y
            shift
            ;;    
        -n|--name)
            name="$2"
            shift 2
            ;;    
        -d|--debug)
            d=y
            shift
            ;;
        -s|--solution)
            s=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -a|--mgandroid)
            a=y
            shift
            ;;
        -o|--mgdesktopgl)
            o=y
            shift
            ;;
        -i|--mgios)
            i=y
            shift
            ;;
        -u|--mguwpcore)
            u=y
            shift
            ;;
        -x|--mguwpxaml)
            x=y
            shift
            ;;
        -w|--mgwindowsdx)
            w=y
            shift
            ;;                                                
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# if we do not have a name as option argument we check 
# check that we do not have more than one non-option argument
if [ -z ${name+x} ]; then
if [[ $# -gt 1 ]]; then
    echo "More than one non-option argument found."
    echo "Please use no non-option argument to use the default value or"
    echo "pass only one non-option argument which will be used as name."
    exit 4
fi
fi

# handle non-option arguments
#if [[ $# -ne 1 ]]; then
#    echo "$0: A single input file is required."
#    exit 4
#fi

if [ $d == y ]; then
echo "help: $h [$help]"
echo "name: $n [$name]"
#
echo "debug: $d [$debug]"
echo "solution: $s [$solution]"
echo "verbose: $v [$verbose]"
#
echo "mgandroid: $a [$mgandroid]"
echo "mgdesktopgl: $o [$mgdesktopgl]"
echo "mgios: $i [$mgios]"
echo "mguwpcore: $u [$mguwpcore]"
echo "mguwpxaml: $x [$mguwpxaml]"
echo "mgwindowsdx: $w [$mgwindowsdx]"
#
echo "projects to generate: "
if [ $a == y ]; then
echo "android"
fi
if [ $o == y ]; then
echo "desktopgl"
fi
if [ $i == y ]; then
echo "ios"
fi
if [ $u == y ]; then
echo "uwpcore"
fi
if [ $x == y ]; then
echo "uwpxaml"
fi
if [ $w == y ]; then
echo "windowsdx"
fi
fi

################################################################################
# COMMAND LINE OPTIONS
################################################################################

# constants
delimiter="################################################################################"
#
android="Android"
desktopgl="OpenGL"
ios="iOS"
uwpcore="UWPCore"
uwpxaml="UWPXaml"
windowsdx="WindowsDX"

# variables
# outputdir="k1/j2/g3"
outputdir=""
solutionname="MonoGameKickstarter"

# parameters
solutionnameparameter="$1"

###########################################################################
SCRIPTPATH="$0"
REALPATH="$(realpath "$SCRIPTPATH")"
BASEPATH="$(dirname "$REALPATH")"
cat "$BASEPATH/MonoGameKickstarterLogoWhite.txt"
###########################################################################

echo "${delimiter}"
echo "This is MonoGameKickstarter ${version}"

# check parameter
echo "${delimiter}"
if [ $# -eq 0 ] ; then
  if [ -z ${solutionname} ] ; then
      echo 'Error: No parameter found and no default solutionname defined.'
      echo 'Please start the script with a parameter for the solutionname or define a default solutionname.'
      echo "Usage: "$(basename $0)" [solutionname]"
      exit 1
  fi
fi

echo 'The script was started with this configuration: '
echo -n 'solutionnameparameter: '
echo "${solutionnameparameter}"
echo -n 'outputdir: '
echo "${outputdir}"
echo -n 'solutionname: '
echo "${solutionname}"

if [ ! -z ${solutionnameparameter} ] ; then
  solutionname=${solutionnameparameter}
fi

# non zero-length string? --> append trailing slash if not existing
[[ -n $outputdir ]] && [[ "${outputdir}" != */ ]] && outputdir="${outputdir}/"
slndir="${outputdir}${solutionname}"

# count subfolders for maxdepth
slndirsubdirs="$(echo ${slndir} | tr -cd '/' | wc -c)"

echo "${delimiter}"
echo 'The script will use these settings: '
echo -n 'solutionnameparameter: '
echo "${solutionnameparameter}"
echo -n 'outputdir: '
echo "${outputdir}"
echo -n 'solutionname: '
echo "${solutionname}"
echo -n 'slndir: '
echo "${slndir}"
echo -n 'slndirsubdirs: '
echo "${slndirsubdirs}"

# check dependencies
# NET Core SDK 
echo "${delimiter}"
if ! [ -x "$(command -v dotnet)" ]; then
  echo 'Error: This script uses dotnet. But it is not installed or executable.'
  exit 1
else
  dotnetversion="$(dotnet --version)"
  echo "dotnet version: ${dotnetversion}"
fi
# MonoGame templates 
echo "${delimiter}"
installtemplatescommand='dotnet new --install MonoGame.Templates.CSharp'
numberofmonogametemplatesinstalled="$(dotnet new --list | grep "MonoGame" | wc -l)"
if [ "${numberofmonogametemplatesinstalled}" -eq 0 ]; then
  echo 'Error: No MonoGame templates found. You can install the templates with:'
  echo ${installtemplatescommand}
  exit 1
else
  dotnet new --list | grep "MonoGame"
fi

# MonoGame templates version
echo "${delimiter}"
echo "MonoGame templates version"
monogametemplatesversionlinenumber="$(dotnet new -u | awk '/MonoGame.Templates.CSharp/{ print NR+3; exit }')"
dotnet new -u | awk -v monogametemplatesversionlinenumber=$monogametemplatesversionlinenumber 'NR==monogametemplatesversionlinenumber { print }'

echo "${delimiter}"
# check if slndir dir exists or try to create it
if [ -d "${slndir}" ]; then
  echo "${slndir} is a directory."
else
  echo "Creating directory "${slndir}" now."
  mkdir -p "${slndir}"
  if [ $? -ne 0 ] ; then
    echo 'Could not create directory for some reason.'
    exit 1
  fi
fi

# check if slndir dir is empty
if [ -z "$(ls -A "${slndir}" 2> /dev/null)" ]; then
  echo "Directory ${slndir} is empty."
else
  echo "Directory ${slndir} is NOT empty. Please restart the script with other start parameter(s)."
  echo 'If you already created a solution and project(s) in this directory with this script and the same parameter(s)'
  echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj""
  echo 'or just'
  echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}""
  echo 'should build and run the project(s).'
  exit 1
fi

# setup MonoGame solution and / or project(s)
echo "${delimiter}"
echo 'Setting up solution and / or project(s) now...'
workingdir="$(pwd)"
cd "$slndir"
# create solution file
echo "create solution file"
dotnet new sln -n "${solutionname}"
# create MonoGame NetStandard Library project for code / content sharing
echo "create MonoGame NetStandard Library project for code / content sharing"
dotnet new mgnetstandard -n "${solutionname}.NetStandardLibrary"
dotnet sln add "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
# create MonoGame Cross-Platform Desktop Application (OpenGL) project
echo "create MonoGame Cross-Platform Desktop Application (OpenGL) project"
dotnet new mgdesktopgl -n "${solutionname}.${desktopgl}"
dotnet sln add "${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
# add references to the MonoGame NetStandard Library to all platform projects
echo "add references to the net standard library to all platform projects"
dotnet add "${solutionname}.${desktopgl}" reference "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame NetStandard Library project and will be used from there
echo "delete files from projects which exist in the net standard library project and will be used from there"
rm -r "${solutionname}.${desktopgl}/Content"
rm "${solutionname}.${desktopgl}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the net standard library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.NetStandardLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.OpenGL/MonoGameKickstarter.OpenGL.csproj`
openglcontentfile="${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".NetStandardLibrary\\Content\\Content.mgcb")}1' ${openglcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.NetStandardLibrary;` to second line of `MonoGameKickstarter.OpenGL/Program.cs`
openglprogramfile="${solutionname}.${desktopgl}/Program.cs"
sed -i "2iusing ${solutionname}.NetStandardLibrary;" ${openglprogramfile}

# information
# cd ${workinddir}
#echo "switching back to $SCRIPTPATH"
#cd $SCRIPTPATH
echo "PWD before is"
pwd
cd $(printf "%0.0s../" $(seq 1 $((slndirsubdirs+1)) ))
echo "PWD after is"
pwd
#
findmaxdepth="3"
findmaxdepthcalc=$((findmaxdepth+slndirsubdirs))
findpath="${slndir}"
echo "findpath is ${findpath}"
echo "findmaxdepthcalc is $findmaxdepthcalc"
echo "pwd is" 
pwd
files="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type f)"
filescount="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type f | wc -l)"
dirs="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type d)"
dirscount="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type d | wc -l)"
#
echo "${delimiter}"
echo "Printing information about generated dir(s) / file(s)"
echo "using maxdepth value of ${findmaxdepth} (${findmaxdepthcalc}):"
echo "${delimiter}"
echo "Created these ${dirscount} dir(s):"
echo "${dirs}" 
echo "${delimiter}"
echo "Created these ${filescount} file(s):"
echo "${files}"

# dotnet run info
echo "${delimiter}"
echo 'You should now be able to build and run the project(s) with'
echo 'the command `dotnet run` from the project folder(s) or by passing the project.csproj file or'
echo 'the project path as argument e.g.' 
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj""
echo 'or just'
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}""

# finished
echo "${delimiter}"
echo 'Everything done! :-)'