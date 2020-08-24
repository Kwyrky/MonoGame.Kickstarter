#! /bin/bash

version="1.0"

# constants
delimiter="################################################################################"
opengl="OpenGL"

# variables
outputdir=""
solutionname="MonoGameKickstarter"

# parameters
solutionnameparameter="$1"

###########################################################################
cat << EOF
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxdOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl.     ;kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO,          .lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0'     ;k0o.     oWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc     cXMMMMWx.    .0MMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMK.    ,KMMMMMMMMWo     dMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMO     xMMMMMMMMMMMMX'    cWMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMO    .0MMMWKOxxk0NMMMW;    cWMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMK.    0MMX:.       ,kMMW;    lMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMN.    OMMd     ..     ,XMW,    kMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMl    oMMO    ,KMMWd    :MMX    .WMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMN.   'WMMd    kMMMMW.   .MMMo    dMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMd    OMMMK    .o00k,    lMMMN.   'WMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMM,   .WMMMM0'           oWMMMMl    KMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMN.   lMMMMMMWk:.    .,dNMMMMMM0    oMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMM0    xMMMMMMMMMMWNNNMMMMMMMMMMN.   ;MMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMk    OMMMMMMMMMMMMMMMMMMMMMMMMW.   'WMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMk    OMMMMMMMMMMMMMMMMMMMMMMMMM'   .WMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMO    kMMMMMMMMMMMMMMMMMMMMMMMMW.   'MMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMK    oMMMMMMMMMMMMMMMMMMMMMMMMN.   :MMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMKc.    ;MMMMMMMMMMMMMMMMMMMMMMMMk     'kWMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMXd.       .NMMMMMMMMMMMMMMMMMMMMMMM;       .:OWMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMWO;     .;    oMMMMMMMMMMMMMMMMMMMMMM0    .'     .oXMMMMMMMMMMMMMM
MMMMMMMMMMMMKl.     ;kWW'    KMMMMMMMMMMMMMMMMMMMMM;    OMKl.     ,kWMMMMMMMMMMM
MMMMMMMMMMx.     .dNMMMMO    ,WMMMMMMMMMMMMMMMMMMMk    ;MMMMMO:     .cXMMMMMMMMM
MMMMMMMMMk    .cKMMMMMMMMl    cWMMMMMMMMMMMMMMMMMK.   .XMMMMMMMNd'    'MMMMMMMMM
MMMMMMMMMx    kMMMMMMMMMMW;    lMMMMMMMMMMMMMMMM0.    0MMMMMMMMMMM'   .MMMMMMMMM
MMMMMMMMMx    kMMMMMMMMMMMN'    lWMMMMMMMMMMMMM0.    OMMMMMMMMMMMM'   .MMMMMMMMM
MMMMMMMMMx    kMMMMMMMMMMWKd     'KMMMMMMMMMMWo     :0NMMMMMMMMMMM'   .MMMMMMMMM
MMMMMMMMMx    kMMMWKkdc,.          oWMMMMMMWO'         .':lx0NWMMM'   .MMMMMMMMM
MMMMMMMMMx    :l,.          .,c'    .oNMMMO'     c;.          .':o.   .MMMMMMMMM
MMMMMMMMMx           .':okKNMMMWx.     ;c.     :XMMMWXOdc;.           .MMMMMMMMM
MMMMMMMMMK.    .;lxKNMMMMMMMMMMMMWk'        .lXMMMMMMMMMMMMWXOdc'.    cMMMMMMMMM
MMMMMMMMMMNOOXWMMMMMMMMMMMMMMMMMMMMMXo,  .c0WMMMMMMMMMMMMMMMMMMMMMN0kKMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
EOF
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
  echo "dotnet run --project "${slndir}/${solutionname}.${opengl}/${solutionname}.${opengl}.csproj""
  echo 'or just'
  echo "dotnet run --project "${slndir}/${solutionname}.${opengl}""
  echo 'should build and run the project(s).'
  exit 1
fi

# setup MonoGame solution and project(s)
echo "${delimiter}"
echo 'Setting up solution and project(s) now...'
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
dotnet new mgdesktopgl -n "${solutionname}.${opengl}"
dotnet sln add "${solutionname}.${opengl}/${solutionname}.${opengl}.csproj"
# add references to the MonoGame NetStandard Library to all platform projects
echo "add references to the net standard library to all platform projects"
dotnet add "${solutionname}.${opengl}" reference "${solutionname}.NetStandardLibrary/${solutionname}.NetStandardLibrary.csproj"
echo $delimiter
# delete files from project(s) which exist in the MonoGame NetStandard Library project and will be used from there
echo "delete files from projects which exist in the net standard library project and will be used from there"
rm -r "${solutionname}.${opengl}/Content"
rm "${solutionname}.${opengl}/Game1.cs"
# change the link in all platform *.csproj project files so that it points to the content of the net standard library project
# --> replace `Content\Content.mgcb` with `..\MonoGameKickstarter.NetStandardLibrary\Content\Content.mgcb` in file `MonoGameKickstarter.OpenGL/MonoGameKickstarter.OpenGL.csproj`
openglcontentfile="${solutionname}.${opengl}/${solutionname}.${opengl}.csproj"
awk -i inplace -v AWK="${solutionname}" '{sub(/Content\\Content.mgcb/,"..\\" AWK ".NetStandardLibrary\\Content\\Content.mgcb")}1' ${openglcontentfile}
# add using directives to the file `Program.cs` of all platform projects
# --> add `using MonoGameKickstarter.NetStandardLibrary;` to second line of `MonoGameKickstarter.OpenGL/Program.cs`
openglprogramfile="${solutionname}.${opengl}/Program.cs"
sed -i "2iusing ${solutionname}.NetStandardLibrary;" ${openglprogramfile}

# dotnet run info
echo "${delimiter}"
echo 'You should now be able to build and run the project(s) with'
echo 'the command `dotnet run` from the project folder(s) or by passing the project.csproj file or'
echo 'the project path as argument e.g.' 
echo "dotnet run --project "${slndir}/${solutionname}.${opengl}/${solutionname}.${opengl}.csproj""
echo 'or just'
echo "dotnet run --project "${slndir}/${solutionname}.${opengl}""

# finished
echo "${delimiter}"
echo 'Everything done! :-)'