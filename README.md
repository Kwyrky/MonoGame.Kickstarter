# MonoGame Kickstarter

![MonoGame Kickstarter](MonoGameKickstarter-Transparent.png)

A bash script that lets you quickly create MonoGame projects ready for cross-platform development.

## Quickstart

```
$ monogame-kickstarter.sh [solutionname]
$ ./monogame-kickstarter.sh "MonoGameKickstarterMG"
$ ./monogame-kickstarter.sh -owa "MonoGameKickstarterMG"
$ ./monogame-kickstarter.sh -o -w -a "MonoGameKickstarterMG"
$ ./monogame-kickstarter.sh --mgdesktopgl --mgwindowsdx --mgandroid "MonoGameKickstarterMG"
```
This is all you need to do and MonoGame Kickstarter will create a solution with a MonoGame .NET Game Library project and an OpenGL project referencing it and optionally projects for Windows DirectX and Android if specified with the parameters. The OpenGL project and optional projects will use code and content (Android has it's own content!) from the MonoGame .NET Game Library project. Just open `Game1.cs` from the MonoGame .NET Game Library project and you can immediately start developing your MonoGame project.

There is some example code provided which puts something on the screen as a starting place but you can of course delete it or change it however you like.

## Parameters

All optional parameters must come before the mandatory parameter for the solutionname / foldername.

At this point the script supports 
1. OpenGL projects (`-o` or `--mgdesktopgl`)
2. Windows DirectX projects (`-w` or `--mgwindowsdx`) 
3. Android projects (`-a` or `--mgandroid`).

For example the command

`monogame-kickstarter.sh -owa [solutionname]`

will generate projects for all three supported project types and one project for the shared code. The mandatory argument [solutionname] will be used as target root folder which the script will create as a subfolder. It is also used as the solutionname for the generated visual studio solution.

## Support

If you like this project and it does help you support me here:

TWITTER: https://twitter.com/Kwyrky3D
YOUTUBE: https://youtube.com/user/kwyrky
KO-FI: https://ko-fi.com/kwyrky
GITHUB: https://github.com/Kwyrky

## Works with Linux and Windows

The script can be used on Linux with **bash** or on Windows with **git bash** which comes with the installation of git for Windows!

You can run the script in git bash and pass either `-w` or `--mgwindowsdx` as parameter to make it generate a Windows DirectX project.

`monogame-kickstarter.sh -w [solutionname]`
`monogame-kickstarter.sh --mgwindowsdx [solutionname]`

If you are using the script mainly on windows and you do want to only generate the Windows DirectX project you can modify and change the default value in the script from generating the OpenGL project `o=y` to `o=n` and turn on the Windows DirectX project by changing `w=n` to `w=y`.

If the default values for both options are turned off you can enable them each time you run the script by passing the corresponding options `-o` or `--mgdesktopgl` and `-w` or `--mgwindowsdx`.

## Demo Videos 

Demo videos are available on my YouTube channel, please subscribe and hit the bell ;-)

https://youtube.com/user/kwyrky

## Additional Info

The parameter `[solutionname]` is optional. If the script is started without a parameter it will use the default value which is set to "MonoGameKickstarter". If you want to make the parameter mandatory you can achieve this by editing the script and setting the variable holding the default value to an empty string e.g. `solutionname=""`. You can also define a parent folder structure where the solution folder will be put in e.g. `outputdir="monogame-kickstarter"`. The script will then create the outputdir(s) first and put everything inside it.

## Dependencies

The script makes use of the **.NET Core SDK** and the official **MonoGame templates** which have to be installed first. For details on how to do this please check the official MonoGame documentation https://docs.monogame.net/.

## What it does

The aim of the script is to provide a convenient (quick) way to set up a new solution which can be used for new multiplatform MonoGame projects. As a starting point it creates a solution containing a **MonoGame .NET Game Library** project and a **MonoGame Cross-Platform Desktop Application (OpenGL)** project as a starting point for development. Later it is possible to manually add or remove more MonoGame projects from the official MonoGame templates to the solution. So there should be no disadvantage in using this script.

Note: The script deletes `Game1.cs` and `Content` generated by the **MonoGame Cross-Platform Desktop Application (OpenGL)** template and then sets up a link to the Content project (Content.mgcb) generated by the **MonoGame .NET Game Library** template. The idea is that the **MonoGame Cross-Platform Desktop Application (OpenGL)** project should use not only the shared code of the **MonoGame .NET Game Library** but also the content of the **MonoGame .NET Game Library** project.

## [OPTIONAL] Install globally

Install the `monogame-kickstarter` command globally (works on linux only):

If you like, you can define a symbolic link so that the script can be used without typing its full path from anywhere. In the following command replace `<MonoGame.Kickstarter>` with the actual path to MonoGame.Kickstarter on your system!

`sudo ln -s <MonoGame.Kickstarter>/monogame-kickstarter.sh /usr/bin/monogame-kickstarter`

e.g. if you cloned this repo to `$HOME/dev/monogame/projects` the command would be

`sudo ln -s $HOME/dev/monogame/projects/MonoGame.Kickstarter/monogame-kickstarter.sh /usr/bin/monogame-kickstarter`

## Note

Not all projects can be generated on each platform. So as default only the **MonoGame Cross-Platform Desktop Application (OpenGL)** template is set to make the script work on Windows (git bash) and Linux (bash).

## Templates

`$ dotnet new --list | grep "MonoGame"`

| Templates                                              | Short Name    | Language | Tags                                         |
|--------------------------------------------------------|---------------|----------|----------------------------------------------|
| MonoGame Android Application                           | mgandroid     | [C#]     | MonoGame/Games/Mobile/Android                |
| MonoGame Content Pipeline Extension                    | mgpipeline    | [C#]     | MonoGame/Games/Extensions                    |
| MonoGame Cross-Platform Desktop Application            | mgdesktopgl   | [C#]     | MonoGame/Games/Desktop/Windows/Linux/macOS   |
| MonoGame Game Library                                  | mglib         | [C#]     | MonoGame/Games/Library                       |
| MonoGame iOS Application                               | mgios         | [C#]     | MonoGame/Games/Mobile/iOS                    |
| MonoGame Shared Library Project                        | mgshared      | [C#]     | MonoGame/Games/Library                       |
| MonoGame Windows Desktop Application                   | mgwindowsdx   | [C#]     | MonoGame/Games/Desktop/Windows/Linux/macOS   |
| MonoGame Windows Universal XAML Application            | mguwpxaml     | [C#]     | MonoGame/Games/Desktop/Windows/Xbox/UWP/XAML |
