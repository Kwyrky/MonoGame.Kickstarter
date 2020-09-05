#! /bin/bash

version="1.02"

scriptname="monogame-kickstarter.sh"

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

OPTIONS=hrcn:dsSvaoiuxw
LONGOPTS=help,rocket,copy,name:,debug,solution,nosolution,verbose,mgandroid,mgdesktopgl,mgios,mguwpcore,mguwpxaml,mgwindowsdx

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
help="$h"
#
r=n
rocket="$r"
#
c=y
copy="$c"
#
n=monogamekickstarter
name="$n"
#
d=y
debug="$d"
#
s=y
solution="$s"
#
S=n
nosolution="$S"
#
v=n
verbose="$v"
#
a=y
mgandroid="$a"
#
o=y
mgdesktopgl="$o"
#
i=n
mgios="$i"
#
u=n
mguwpcore="$u"
#
x=n
mguwpxaml="$x"
#
w=n
mgwindowsdx="$w"


# initial values of variables to keep track of some things
numprojects=0
#
numsolutionargs=0
#
nameparameterset=n

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            h=y
            help="$h"
            shift
            ;;   
        -r|--rocket)
            r=y
            rocket="$r"
            shift
            ;;   
        -c|--copy)
            c=y
            copy="$c"
            shift
            ;;                            
        -n|--name)
            n="$2"
            name="$2"
            nameparameterset=y
            shift 2
            ;;    
        -d|--debug)
            d=y
            debug="$d"
            shift
            ;;
        -s|--solution)
            numsolutionargs=$((numsolutionargs+1))
            s=y
            solution="$s"
            shift
            ;;
        -S|--nosolution)
            numsolutionargs=$((numsolutionargs+1))
            S=y
            nosolution="$S"
            shift
            ;;
        -v|--verbose)
            v=y
            verbose="$v"
            shift
            ;;
        -a|--mgandroid)
            a=y
            mgandroid="$a"
            shift
            ;;
        -o|--mgdesktopgl)
            o=y
            mgdesktopgl="$o"
            shift
            ;;
        -i|--mgios)
            i=y
            mgios="$i"
            shift
            ;;
        -u|--mguwpcore)
            u=y
            mguwpcore="$u"
            shift
            ;;
        -x|--mguwpxaml)
            x=y
            mguwpxaml="$x"
            shift
            ;;
        -w|--mgwindowsdx)
            w=y
            mgwindowsdx="$w"
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
# that we do not have more than one non-option argument
if [ -z ${name+x} ]; then
if [[ $# -gt 1 ]]; then
    echo "More than one non-option argument found."
    echo "Please use no non-option argument to use the default value or"
    echo "pass only one non-option argument which will be used as name."
    exit 4
fi
fi

if [ $d == y ]; then
echo "help: $h [$help]"
echo "rocket: $r [$rocket]"
echo "copy: $c [$copy]"
echo "name: $n [$name]"
#
echo "debug: $d [$debug]"
echo "solution: $s [$solution]"
echo "nosolution: $S [$nosolution]"
echo "verbose: $v [$verbose]"
#
echo "mgandroid: $a [$mgandroid]"
echo "mgdesktopgl: $o [$mgdesktopgl]"
echo "mgios: $i [$mgios]"
echo "mguwpcore: $u [$mguwpcore]"
echo "mguwpxaml: $x [$mguwpxaml]"
echo "mgwindowsdx: $w [$mgwindowsdx]"
#
echo "${delimiter}"
echo -n "solution: "
if [ $s == y ]; then
  echo "create solution"
else
  echo "don't create solution"
fi
#
echo -n "nosolution: "
if [ $S == y ]; then
  echo "don't create solution"
else
  echo "create solution"
fi
#
if [ $numsolutionargs -gt 1 ] ; then
  echo "Error: conflicting arguments -s / --solution and -S / --nosolution"
  echo "Please define either -s / --solution or -S / --nosolution"
  exit 5
fi
#
# We know that we only have one of the arguments of -s and -S so if we found 
# -S we set -s to n to deactivate the creation of the sln file which only
# happens if the value of -s is set to y
if [ $S == y ] ; then
s=n
solution="$s"
fi
#
echo "${delimiter}"
echo "projects to generate: "
if [ $a == y ]; then
numprojects=$((numprojects+1))
echo "android"
fi
#
if [ $o == y ]; then
numprojects=$((numprojects+1))
echo "desktopgl"
fi
if [ $i == y ]; then
numprojects=$((numprojects+1))
echo "ios"
fi
if [ $u == y ]; then
numprojects=$((numprojects+1))
echo "uwpcore"
fi
if [ $x == y ]; then
numprojects=$((numprojects+1))
echo "uwpxaml"
fi
if [ $w == y ]; then
numprojects=$((numprojects+1))
echo "windowsdx"
fi
fi
#
echo "${delimiter}"
echo "number of projects to generate: ${numprojects}"
#
if [ ! ${numprojects} -gt 0 ] ; then
echo "Error: No project(s) to generate. Please define at least one project"
echo "to be generated e.g. to generate projects using the"
echo "mgdesktopgl (-o or --mgdesktopgl) and"
echo "mgwindowsdx (-w or --mgwindowsdx) templates use"
echo "${scriptname} -ow solutionname"
echo "or using the long options"
echo "${scriptname} --mgdesktopgl --mgwindowsdx solutionname"
exit 6
fi
#

################################################################################
# FUNCTIONS
################################################################################

function echoverbose()
{
if [ $v == y ]; then
echo "$1"
fi
}

function echodebug()
{
if [ $d == y ]; then
echo "$1"
fi
}

# parameters
if [ $nameparameterset == y ]; then
solutionnameparameter="$n"
else
solutionnameparameter="$1"
fi

###########################################################################
SCRIPTPATH="$0"
REALPATH="$(realpath "$SCRIPTPATH")"
BASEPATH="$(dirname "$REALPATH")"
if [ $r == y ]; then
cat "$BASEPATH/MonoGameKickstarterLogoWhite.txt"
else
echo "${delimiter}"
fi
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
  echo 'Error: This script uses dotnet. But it is not installed or not executable.'
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
    echo 'Could not create directory.'
    exit 1
  fi
fi

# check if slndir dir is empty
if [ -z "$(ls -A "${slndir}" 2> /dev/null)" ]; then
  echo "Directory ${slndir} is empty."
else
  echo "Directory ${slndir} is NOT empty. Please restart the script with other start parameter(s)."
  echo "If you already created a solution and project(s) in this directory with this script and the same parameter(s)"
  echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj""
  echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}""
  echo "should build and run the project(s)."
  exit 1
fi

################################################################################
# SETUP MONOGAME SOLUTION AND / OR PROJECT(S)
################################################################################

echo "${delimiter}"
echoverbose 'Setting up solution and / or project(s) now...'
workingdir="$(pwd)"
cd "$slndir"

# create MonoGame NetStandard Library project for code / content sharing
echoverbose "create MonoGame NetStandard Library project for code / content sharing"
dotnet new mgnetstandard -n "${solutionname}.NetStandardLibrary"
echo "${delimiter}"

################################################################################
# DESKTOP GL

if [ $o == y ]; then
# create MonoGame Cross-Platform Desktop Application (OpenGL) project
echoverbose "create MonoGame Cross-Platform Desktop Application (OpenGL) project"
dotnet new mgdesktopgl -n "${solutionname}.${desktopgl}"

# add references to the MonoGame NetStandard Library to all platform projects
echoverbose "add references to the net standard library to all platform projects"
dotnet add "${solutionname}.${desktopgl}" reference "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame NetStandard Library project and will be used from there
echoverbose "delete files from projects which exist in the net standard library project and will be used from there"
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
fi

################################################################################
# WINDOWS DX

if [ $w == y ]; then
# create MonoGame Windows Desktop Application (Windows DirectX) project
echoverbose "create MonoGame Windows Desktop Application (Windows DirectX) project"
dotnet new mgwindowsdx -n "${solutionname}.${windowsdx}"

# add references to the MonoGame NetStandard Library to all platform projects
echoverbose "add references to the net standard library to all platform projects"
dotnet add "${solutionname}.${windowsdx}" reference "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame NetStandard Library project and will be used from there
echoverbose "delete files from projects which exist in the net standard library project and will be used from there"
rm -r "${solutionname}.${windowsdx}/Content"
rm "${solutionname}.${windowsdx}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the net standard library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.NetStandardLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.WindowsDX/MonoGameKickstarter.WindowsDX.csproj`
windowsdxcontentfile="${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".NetStandardLibrary\\Content\\Content.mgcb")}1' ${windowsdxcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.NetStandardLibrary;` to second line of `MonoGameKickstarter.WindowsDX/Program.cs`
windowsdxprogramfile="${solutionname}.${windowsdx}/Program.cs"
sed -i "2iusing ${solutionname}.NetStandardLibrary;" ${windowsdxprogramfile}
fi

################################################################################
# ANDROID

if [ $a == y ]; then
# create MonoGame Android Application project
echoverbose "create MonoGame Android Application project"
dotnet new mgandroid -n "${solutionname}.${android}"

# add references to the MonoGame NetStandard Library to all platform projects
echoverbose "add references to the net standard library to all platform projects"
dotnet add "${solutionname}.${android}" reference "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame NetStandard Library project and will be used from there
echoverbose "delete files from projects which exist in the net standard library project and will be used from there"

# For ANDROID we leave the original Content folder provided by the Android template where it is 
# because maybe for an app you want to add modified content in some way at some point
# We just add the content from the net standard project so that it is available in the shared code
# and we get a working App from the start.
### rm -r "${solutionname}.${android}/Content"

rm "${solutionname}.${android}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the net standard library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.NetStandardLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.WindowsDX/MonoGameKickstarter.WindowsDX.csproj`
androidcontentfile="${solutionname}.${android}/${solutionname}.${android}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".NetStandardLibrary\\Content\\Content.mgcb")}1' ${androidcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.NetStandardLibrary;` to second line of `MonoGameKickstarter.WindowsDX/Program.cs`
androidactivityfile="${solutionname}.${android}/Activity1.cs"
sed -i "2iusing ${solutionname}.NetStandardLibrary;" ${androidactivityfile}
fi

################################################################################
# copy sample files

# if [ $c == y ]; then
# dirnamesamplefiles="mgks"
# Effect effect = Content.Load<Effect>("effect")
# fi

################################################################################

if [ $s == y ]; then
# create solution file
echoverbose "create solution file"
dotnet new sln -n "${solutionname}"
#
echoverbose "Adding NetStandardLibrary project to solution"
dotnet sln add "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
#
if [ $a == y ]; then
echoverbose "Adding android project to solution"
dotnet sln add "${solutionname}.${android}/${solutionname}.${android}.csproj"
fi
#
if [ $o == y ]; then
echoverbose "Adding desktopgl project to solution"
dotnet sln add "${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
fi
#
if [ $w == y ]; then
echoverbose "Adding windowsdx project to solution"
dotnet sln add "${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
fi
#
fi

################################################################################
# PRINT INFORMATION
################################################################################

if [ $d == y ]; then
  echo "${delimiter}"
  # cd ${workinddir}
  # echo "switching back to $SCRIPTPATH"
  # cd $SCRIPTPATH
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
fi
#
files="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type f)"
filescount="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type f | wc -l)"
dirs="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type d)"
dirscount="$(find ${findpath} -maxdepth ${findmaxdepthcalc} -type d | wc -l)"
#
echo "${delimiter}"
echoverbose "Printing information about generated dir(s) / file(s)"
echodebug "using maxdepth value of ${findmaxdepth} (${findmaxdepthcalc}):"
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
if [ $a == y ]; then
echo "dotnet run --project "${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${android}""
fi
if [ $o == y ]; then
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}""
fi
if [ $w == y ]; then
echo "dotnet run --project "${slndir}/${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${windowsdx}""
fi

# finished
echo "${delimiter}"
echo 'Everything done! :-)'

# TODO
# add to sln
# add reference to net standard
# remove <android>.csproj line 57: <Compile Include="Game1.cs" />
# change awk replace of content with add to have both the android content and shared content
