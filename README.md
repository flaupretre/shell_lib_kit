shell\_lib\_kit allows to generate a shell library, following the model used for [the sysfunc library](http://sysfunc.tekwire.net).

This provides an empty framework where you just need to store your shell functions. The generated library includes everything needed to version and distribute your library in tar/gz or rpm format.

## Usage

Clone or download the file tree

cd to the base directory

Set the configuration variables (see next chapter)

Determine the target directory, where your library will be generated. This directory must not exist.

Run:

    ./genlib.sh <target-dir>

This will generate an empty library in \<target-dir\>.

Optional: run 'git init' in the prog subdirectory.

You can start adding code in the prog/src/scripts subdirectory. Use the 'script_template' file as an example.

In order to distribute your code, cd to the 'prog' subdirectory, adjust library version in 'prog/config.mk', and run 'make tgz' or 'make rpm'.

For more information, refer to [the code of the sysfunc library](https://github.com/flaupretre/sysfunc).


## Configuration variables

These environment variables must be set and exported before the generation script is launched :

- SLK\_PREFIX: Function prefix (without '_'). All your functions must start with this prefix.
- SLK\_LIBNAME: Library name (ex: saplib, dblib). This will be the package name and the command to load the library.
- SLK\_OWNER: Library owner. Information only.
- SLK\_INSTALL\_DIR: Library installation directory. I generally use '/opt/\<library name\>'.

