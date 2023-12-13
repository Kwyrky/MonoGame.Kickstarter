#! /bin/bash

version="1.08"

scriptname="monogame-kickstarter.sh"

# constants
delimiter="################################################################################"
#
gamelibrary="GameLibrary"
#
android="Android"
desktopgl="DesktopGL"
ios="iOS"
uwpcore="UWPCore"
uwpxaml="UWPXaml"
windowsdx="WindowsDX"
#
# files needed for the splash screen
# "*source*" consts are the names of the files in the script base dir or defined base dir
# "*target*" consts are the names of the files in the android project dir (inside the respective subdirs)
# look at the cp commands at the bottom of the script
#
androidbasedir="mgks-resources"
androidsplashimagesource="MonoGameKickstarter-Splash-1080x1920.png"
androidsplashimagetarget="Splash.png"
androidsplashstylessource="Styles.xml"
androidsplashstylestarget="Styles.xml"
androidactivity1="Activity1.cs"
#
# sample files dir
dirnamesamplefiles="mgks"
content="Content"
# sample files for GameLibrary library
samplefilesgamelibraryeffectsource="effect.fx"
samplefilesgamelibraryeffectarget="effect.fx"
samplefilesgamelibrarytexturesource="texture.png"
samplefilesgamelibrarytexturetarget="texture.png"
samplefilesgamelibrarycontentsource="Content.mgcb"
samplefilesgamelibrarycontenttarget="Content.mgcb"
# sample files for android
samplefilesandroideffectsource="androideffect.fx"
samplefilesandroideffectarget="androideffect.fx"
samplefilesandroidtexturesource="androidtexture.png"
samplefilesandroidtexturetarget="androidtexture.png"
samplefilesandroidcontentsource="AndroidContent.mgcb"
samplefilesandroidcontenttarget="AndroidContent.mgcb"
samplefilesandroidcontentgenerated="Content.mgcb"
# sample files containing sample source code for GameLibrary library
samplefilesgame1source="Game1.cs"
samplefilesgame1target="Game1.cs"

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

OPTIONS=hrcn:dzsSvaoiuxw
LONGOPTS=help,rocket,copy,name:,debug,showcommands,solution,nosolution,verbose,mgandroid,mgdesktopgl,mgios,mguwpcore,mguwpxaml,mgwindowsdx

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
# if you want different defaults just change the "y" and "n" in the following lines for
# each option.
# The default settings are copied to the long names in the respective next line.
#
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
z=n
showcommands="$z"
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
w=y
mgwindowsdx="$w"


# initial values of variables to keep track of some things / for debug
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
        -z|--showcommands)
            z=y
            showcommands="$z"
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
# we want either no non-option argument (which will be taken as the solution name)
# or we want exactly one non-option argument which will be used as solution name
if [ -z ${name+x} ]; then
if [[ $# -gt 1 ]]; then
    echo "More than one non-option argument found."
    echo "Please use no non-option argument to use the default value OR"
    echo "pass only one non-option argument which will be used as name."
    exit 4
fi
fi

# output debug information if option argument d is set to y (d=y in the lines above)
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
cat "$BASEPATH/$androidbasedir/MonoGameKickstarterLogoWhite.txt"
else
echo "${delimiter}"
fi
###########################################################################

echo "${delimiter}"
echo "This is MonoGameKickstarter ${version} for MonoGame 3.8.1.303"

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

# create MonoGame GameLibrary Library project for code / content sharing
echoverbose "create MonoGame GameLibrary Library project for code / content sharing"
dotnet new mglib -n "${solutionname}.${gamelibrary}"
echo "${delimiter}"

################################################################################
# DESKTOP GL

if [ $z == y ]; then
set -x
fi

if [ $o == y ]; then
# create MonoGame Cross-Platform Desktop Application (OpenGL) project
echoverbose "create MonoGame Cross-Platform Desktop Application (OpenGL) project"
dotnet new mgdesktopgl -n "${solutionname}.${desktopgl}"

# add references to the MonoGame GameLibrary Library to all platform projects
echoverbose "add references to the GameLibrary library to all platform projects"
dotnet add "${solutionname}.${desktopgl}" reference "${solutionname}.${gamelibrary}/${solutionname}.${gamelibrary}.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame GameLibrary Library project and will be used from there
echoverbose "delete files from projects which exist in the GameLibrary library project and will be used from there"
rm -r "${solutionname}.${desktopgl}/Content"
rm "${solutionname}.${desktopgl}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the GameLibrary library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.GameLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.OpenGL/MonoGameKickstarter.OpenGL.csproj`
openglcontentfile="${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".GameLibrary\\Content\\Content.mgcb")}1' ${openglcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.GameLibrary;` to second line of `MonoGameKickstarter.OpenGL/Program.cs`
openglprogramfile="${solutionname}.${desktopgl}/Program.cs"
sed -i "2iusing ${solutionname}.${gamelibrary};" ${openglprogramfile}
sed -i "3d" ${openglprogramfile}
sed -i "3iusing var game = new ${solutionname}.${gamelibrary}.Game1();" ${openglprogramfile}
fi

if [ $z == y ]; then
set +x
fi 

################################################################################
# WINDOWS DX

if [ $w == y ]; then
# create MonoGame Windows Desktop Application (Windows DirectX) project
echoverbose "create MonoGame Windows Desktop Application (Windows DirectX) project"
dotnet new mgwindowsdx -n "${solutionname}.${windowsdx}"

# add references to the MonoGame GameLibrary Library to all platform projects
echoverbose "add references to the GameLibrary library to all platform projects"
dotnet add "${solutionname}.${windowsdx}" reference "${solutionname}.${gamelibrary}/${solutionname}.${gamelibrary}.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame GameLibrary Library project and will be used from there
echoverbose "delete files from projects which exist in the GameLibrary library project and will be used from there"
rm -r "${solutionname}.${windowsdx}/Content"
rm "${solutionname}.${windowsdx}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the GameLibrary library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.GameLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.WindowsDX/MonoGameKickstarter.WindowsDX.csproj`
windowsdxcontentfile="${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".GameLibrary\\Content\\Content.mgcb")}1' ${windowsdxcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.GameLibrary;` to second line of `MonoGameKickstarter.WindowsDX/Program.cs`
windowsdxprogramfile="${solutionname}.${windowsdx}/Program.cs"
sed -i "2iusing ${solutionname}.${gamelibrary};" ${windowsdxprogramfile}
sed -i "3d" ${windowsdxprogramfile}
sed -i "3iusing var game = new ${solutionname}.${gamelibrary}.Game1();" ${windowsdxprogramfile}
fi

################################################################################
# ANDROID

if [ $z == y ]; then
set -x
fi

if [ $a == y ]; then
# create MonoGame Android Application project
echoverbose "create MonoGame Android Application project"
dotnet new mgandroid -n "${solutionname}.${android}"

# add references to the MonoGame GameLibrary Library to all platform projects
echoverbose "add references to the GameLibrary library to all platform projects"
dotnet add "${solutionname}.${android}" reference "${solutionname}.${gamelibrary}/${solutionname}.${gamelibrary}.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame GameLibrary Library project and will be used from there
echoverbose "delete files from projects which exist in the GameLibrary library project and will be used from there"

# For ANDROID we leave the original Content folder provided by the Android template where it is 
# because maybe for an app you want to add modified content in some way at some point
# We just add the content from the GameLibrary project so that it is available in the shared code
# and we get a working App from the start.
### rm -r "${solutionname}.${android}/Content"

rm "${solutionname}.${android}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the GameLibrary library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.GameLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.WindowsDX/MonoGameKickstarter.WindowsDX.csproj`
androidcontentfile="${solutionname}.${android}/${solutionname}.${android}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".GameLibrary\\Content\\Content.mgcb")}1' ${androidcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.GameLibrary;` to second line of `MonoGameKickstarter.WindowsDX/Program.cs`
#### androidactivityfile="${solutionname}.${android}/${androidactivity1}"
androidactivityfile="${solutionname}.${android}/Activity1.cs"
sed -i "2iusing ${solutionname}.${gamelibrary};" ${androidactivityfile}
fi

if [ $z == y ]; then
set +x
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
echoverbose "Adding ${gamelibrary} project to solution"
dotnet sln add "${solutionname}.${gamelibrary}/${solutionname}.${gamelibrary}.csproj"
#
if [ $a == y ]; then
echoverbose "Adding ${android} project to solution"
dotnet sln add "${solutionname}.${android}/${solutionname}.${android}.csproj"
fi
#
if [ $o == y ]; then
echoverbose "Adding ${desktopgl} project to solution"
dotnet sln add "${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
fi
#
if [ $w == y ]; then
echoverbose "Adding ${windowsdx} project to solution"
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
# echo "dotnet run --project "${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj""
# echo "dotnet run --project "${slndir}/${solutionname}.${android}""
echo "${delimiter}"
echo "For Android manual steps are needed: "
echo ""
echo "1. Open the solution in Visual Studio and right click the solution in the solution explorer to open the solution properties."
echo "2. For Configuration select 'All Configurations' from the combo box"
echo "3. Select 'Configuration Properties' on the list to show the 'project contexts'"
echo "4. Make sure that for the Android project contexts both checkboxes for build and deploy are checked!"
echo "5. It should now be possible to build and deploy the Android app in Visual Studio if an android emulator is configured or"
echo " a real device is connected and available in Visual Studio"
echo ""

fi
echo "${delimiter}"
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${desktopgl}""
if [ $w == y ]; then
echo "dotnet run --project "${slndir}/${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${windowsdx}""
fi
if [ $a == y ]; then
echo "dotnet run --project "${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj""
echo "dotnet run --project "${slndir}/${solutionname}.${android}""
fi

# copy files needed for splash screen
if [ $a == y ]; then
echo "${delimiter}"
echoverbose "Copy splash screen files to ${android} project"
cp "$BASEPATH/$androidbasedir/$androidsplashimagesource" "$BASEPATH/${slndir}/${solutionname}.${android}/Resources/Drawable/$androidsplashimagetarget"
cp "$BASEPATH/$androidbasedir/$androidsplashstylessource" "$BASEPATH/${slndir}/${solutionname}.${android}/Resources/Values/$androidsplashstylestarget"
# TODO check if source files exist and verify files got copied after cp commands
# only if cp commands were successful modify the android project's Activity1.cs to use the splash image!
# add line to Activity1.cs
# since we jumped up a directory before we need to compensate for this! So unlike above we here use
# ${slndir}/${androidactivityfile}
# not
# ${androidactivityfile}
# 
# --> add `        Theme = "@style/Theme.Splash",` to line 14 of `MonoGameKickstarter.Android/Activity1.cs`
androidactivityfile="${solutionname}.${android}/${androidactivity1}"
sed -i "14i        Theme = \"@style/Theme.Splash\"," ${slndir}/${androidactivityfile}
#
androidproj="${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj"
# --> add `        <AndroidResource Include="Resources\Drawable\Splash.png" />` to line 62 of `MonoGameKickstarter.Android/MonoGameKickstarter.Android.csproj`
sed -i '63i    <AndroidResource Include="Resources\\\Drawable\\\'${androidsplashimagetarget}'" />' "${androidproj}"
# --> add `        <AndroidResource Include="Resources\Values\Styles.xml" />` to line 64 of `MonoGameKickstarter.Android/MonoGameKickstarter.Android.csproj`
sed -i '65i    <AndroidResource Include="Resources\\\Values\\\'${androidsplashstylestarget}'" />' "${androidproj}"
#
# --> delete line 57 `    <Compile Include="Game1.cs" />` from `MonoGameKickstarter.Android/MonoGameKickstarter.Android.csproj`
sed -i '57d' "${androidproj}"
fi
#
# copy mgks files to GameLibrary project
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesgamelibraryeffectsource}" "$BASEPATH/${slndir}/${solutionname}.${gamelibrary}/${content}/${samplefilesgamelibraryeffectarget}"
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesgamelibrarytexturesource}" "$BASEPATH/${slndir}/${solutionname}.${gamelibrary}/${content}/${samplefilesgamelibrarytexturetarget}"
rm "$BASEPATH/${slndir}/${solutionname}.${gamelibrary}/${content}/${samplefilesgamelibrarycontenttarget}"
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesgamelibrarycontentsource}" "$BASEPATH/${slndir}/${solutionname}.${gamelibrary}/${content}/${samplefilesgamelibrarycontenttarget}"
#
if [ $a == y ]; then
# copy mgks files to android project
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesandroideffectsource}" "$BASEPATH/${slndir}/${solutionname}.${android}/${content}/${samplefilesandroideffectarget}"
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesandroidtexturesource}" "$BASEPATH/${slndir}/${solutionname}.${android}/${content}/${samplefilesandroidtexturetarget}"
rm "$BASEPATH/${slndir}/${solutionname}.${android}/${content}/${samplefilesandroidcontentgenerated}"
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesandroidcontentsource}" "$BASEPATH/${slndir}/${solutionname}.${android}/${content}/${samplefilesandroidcontenttarget}"
#
fi
# copy Game1.cs with sample code from mgks folder to GameLibrary project folder
cp "$BASEPATH/${dirnamesamplefiles}/${samplefilesgame1source}" "$BASEPATH/${slndir}/${solutionname}.${gamelibrary}/${samplefilesgame1target}"
#
# add Game1.cs from GameLibrary project as link
sed -i '56i    <Compile Include="..\\\'${solutionname}.${gamelibrary}'\\\Game1.cs" Link="Game1ANDROID">' "${androidproj}"
sed -i '57i    <Link>Game1.cs</Link>' "${androidproj}"
sed -i '58i    </Compile>' "${androidproj}"
# add     <None Include="Content\AndroidContent.mgcb" />
sed -i '71i     <None Include="Content\\\'${samplefilesandroidcontenttarget}'" />' "${androidproj}"
#
# replace namespace in sample Game1.cs "template"
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.GameLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.OpenGL/MonoGameKickstarter.OpenGL.csproj`
game1targetfile="${slndir}/${solutionname}.${gamelibrary}/${samplefilesgame1target}"
namespacereplacestring="${solutionname}"
awk -i inplace -v AWK="${namespacereplacestring}" '{sub(/MONOGAMEKICKSTARTERNAMESPACE/,AWK)}1' ${game1targetfile}
#
#öö# replace public by internal in Game1 to avoid CS0436 
#öö# --> Warning CS0436 The type 'Game1' in 'slnname.GameLibrary\Game1.cs' conflicts with the imported type 'Game1' in 'slnname.GameLibrary, #ööVersion=1.0.0.0, Culture=neutral, PublicKeyToken=null'. Using the type defined in 'slnname.GameLibrary\Game1.cs'.
#ööaccessmodifierreplacestring="internal class "
#ööawk -i inplace -v AWK="${accessmodifierreplacestring}" '{sub(/public class /,AWK)}1' ${game1targetfile}
#
if [ $w == y ]; then
# add Game1.cs from GameLibrary project as link to WinDX project (TODO check if option set! / project exists)
windowsdxprojectfullpath="${slndir}/${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
sed -i '21i    <ItemGroup>' "${windowsdxprojectfullpath}"
sed -i '22i    <Compile Include="..\\\'${solutionname}.${gamelibrary}'\\\Game1.cs" Link="Game1.cs" />' "${windowsdxprojectfullpath}"
sed -i '23i    </ItemGroup>' "${windowsdxprojectfullpath}"
fi
#
# add Game1.cs from GameLibrary project as link to OpenGL project (TODO check if option set! / project exists)
# we seem to have a slight template difference, so we need to add the lines one line further in comparison
# with the windowsdx project
desktopglprojectfullpath="${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
sed -i '21i    <ItemGroup>' "${desktopglprojectfullpath}"
sed -i '22i    <Compile Include="..\\\'${solutionname}.${gamelibrary}'\\\Game1.cs" Link="Game1.cs" />' "${desktopglprojectfullpath}"
sed -i '23i    </ItemGroup>' "${desktopglprojectfullpath}"
#
# ??????????????????????????????????????????????????????????????????
# ??????????????????????????????????????????????????????????????????
# ??????????????????????????????????????????????????????????????????
# add CCS / conditional compilation symbols
if [ $w == y ]; then
# add CCS WINDOWSDX (TODO check if option set! / project exists)
# <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|AnyCPU'">
#  <DefineConstants>TRACE;WINDOWSDX</DefineConstants>
# </PropertyGroup>
# TIPP: replacing ' with '\'' helps...
windowsdxprojectfullpath="${slndir}/${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
sed -i '14i    <PropertyGroup Condition="'\''$(Configuration)|$(Platform)'\''=='\''Debug|AnyCPU'\''">' "${windowsdxprojectfullpath}"
sed -i '15i     <DefineConstants>TRACE;WINDOWSDX</DefineConstants>' "${windowsdxprojectfullpath}"
sed -i '16i    </PropertyGroup>' "${windowsdxprojectfullpath}"
fi
#########################################äääääääääää
if [ $w == y ]; then
# add MonoGameContentReference WINDOWSDX
# TIPP: replacing ' with '\'' helps...
#	<ItemGroup>
#		<MonoGameContentReference Include="..\GAMELIBTEST7.GameLibrary\Content\Content.mgcb" />
#	</ItemGroup>
windowsdxprojectfullpath="${slndir}/${solutionname}.${windowsdx}/${solutionname}.${windowsdx}.csproj"
sed -i '21i    <ItemGroup>' "${windowsdxprojectfullpath}"
sed -i '22i     <MonoGameContentReference Include="..\\\'${solutionname}.${gamelibrary}'\\\Content\\\'${samplefilesgamelibrarycontenttarget}'" />' "${windowsdxprojectfullpath}"
sed -i '23i    </ItemGroup>' "${windowsdxprojectfullpath}"
fi
###########################################äääää
#
# add CCS DESKTOPGL (TODO check if option set! / project exists)
# <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|AnyCPU'">
#   <DefineConstants>TRACE;DESKTOPGL</DefineConstants>
# </PropertyGroup>
# TIPP: replacing ' with '\'' helps...
desktopglprojectfullpath="${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
sed -i '13i    <PropertyGroup Condition="'\''$(Configuration)|$(Platform)'\''=='\''Debug|AnyCPU'\''">' "${desktopglprojectfullpath}"
sed -i '14i      <DefineConstants>TRACE;DESKTOPGL</DefineConstants>' "${desktopglprojectfullpath}"
sed -i '15i    </PropertyGroup>' "${desktopglprojectfullpath}"
# ??????????????????????????????????????????????????????????????????
# ??????????????????????????????????????????????????????????????????
# ??????????????????????????????????????????????????????????????????
#########################################äääääääääää
# add MonoGameContentReference DESKTOPGL
# TIPP: replacing ' with '\'' helps...
#	<ItemGroup>
#		<MonoGameContentReference Include="..\GAMELIBTEST7.GameLibrary\Content\Content.mgcb" />
#	</ItemGroup>
desktopglprojectfullpath="${slndir}/${solutionname}.${desktopgl}/${solutionname}.${desktopgl}.csproj"
sed -i '20i    <ItemGroup>' "${desktopglprojectfullpath}"
sed -i '21i     <MonoGameContentReference Include="..\\\'${solutionname}.${gamelibrary}'\\\Content\\\'${samplefilesgamelibrarycontenttarget}'" />' "${desktopglprojectfullpath}"
sed -i '22i    </ItemGroup>' "${desktopglprojectfullpath}"
###########################################äääää
#ANDROID

#üüü  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|AnyCPU'">
#üüü    <DefineConstants>$(DefineConstants)TRACE;ANDROID</DefineConstants>
#üüü  </PropertyGroup>
#
#üüü  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|AnyCPU'">
#üüü    <DefineConstants>$(DefineConstants)TRACE;ANDROID</DefineConstants>
#üüü  </PropertyGroup>
#
#üüü  <ItemGroup>
#üüü    <Compile Include="..\GAMELIBTEST06.GameLibrary\Game1.cs" Link="Game1.cs" />
#üüü  </ItemGroup>

#########################################äääääääääää
if [ $a == y ]; then
# add CCS and link to Game Library Game1.cs ANDROID
# TIPP: replacing ' with '\'' helps...
androidprojectfullpath="${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj"
sed -i '10i    <PropertyGroup Condition="'\''$(Configuration)|$(Platform)'\''=='\''Debug|AnyCPU'\''">' "${androidprojectfullpath}"
sed -i '11i      <DefineConstants>$(DefineConstants)TRACE;ANDROID</DefineConstants>' "${androidprojectfullpath}"
sed -i '12i    </PropertyGroup>' "${androidprojectfullpath}"
sed -i '13i    <PropertyGroup Condition="'\''$(Configuration)|$(Platform)'\''=='\''Release|AnyCPU'\''">' "${androidprojectfullpath}"
sed -i '14i      <DefineConstants>$(DefineConstants)TRACE;ANDROID</DefineConstants>' "${androidprojectfullpath}"
sed -i '15i    </PropertyGroup>' "${androidprojectfullpath}"
sed -i '16i    <ItemGroup>' "${androidprojectfullpath}"
sed -i '17i    <Compile Include="..\\\'${solutionname}.${gamelibrary}'\\\Game1.cs" Link="Game1.cs" />' "${androidprojectfullpath}"
sed -i '18i    </ItemGroup>' "${androidprojectfullpath}"
###########################################äääää
# add Content references ANDROID
#
#üüü	<ItemGroup>
#üüü		<MonoGameContentReference Include="..\GAMELIBTEST06.GameLibrary\Content\Content.mgcb" Visible="false" />
#üüü		<MonoGameContentReference Include="Content\AndroidContent.mgcb" />
#üüü	</ItemGroup>
#
androidprojectfullpath="${slndir}/${solutionname}.${android}/${solutionname}.${android}.csproj"
sed -i '26i    <ItemGroup>' "${androidprojectfullpath}"
sed -i '27i     <MonoGameContentReference Include="..\\\'${solutionname}.${gamelibrary}'\\\Content\\\Content.mgcb" Visible="false" />' "${androidprojectfullpath}"
sed -i '28i     <MonoGameContentReference Include="Content\\\'${samplefilesandroidcontenttarget}'" />' "${androidprojectfullpath}"
sed -i '29i    </ItemGroup>' "${androidprojectfullpath}"
fi
###########################################äääää

# finished
echo "${delimiter}"
echo 'Everything done! :-)'