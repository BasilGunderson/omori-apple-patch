# Patch script

*How do I apply the patch?*


## Preparation

Make sure you have Steam installed, and OMORI is downloaded within Steam. Launch the game at least once after downloading it. It'll probably crash but that's okay.


## If you're on Apple Silicon:

### Download

Download the latest version of the patch script (omori-apple-silicon-patch.command) from the [releases](https://github.com/BasilGunderson/omori-apple-patch/releases/latest) page.

### Run the patch

Within Finder, control+click the patch script and choose `Open` to execute it. A terminal should pop up with progress information.

Once the process has finished, indicated by `Done!` in the output and `[Process completed]` at the bottom of the terminal, quit terminal and launch OMORI through Steam.

### Troubleshooting

If MacOS complains about the security of the file, or it's "not executable", open a Terminal within the enclosing folder of the script and execute `chmod +x ./omori-apple-silicon-patch.command`. After that, try running the patch again.


## If you're on Apple Intel:

### Run the patch

Open a Terminal, then run this command `bash <(curl -s https://raw.githubusercontent.com/BasilGunderson/omori-apple-patch/main/omori-apple-intel-patch.sh)`

### Alternatively, for manual install

Download the repository and run this command `chmod +x path_to_sh_file_in_cloned_repo`

After that, drag the .sh file into your terminal (or enter the path to the sh) and press Enter.

Once the process has finished, quit terminal and launch OMORI through Steam.


# Uninstall

Simply verify the integrity of your OMORI game files through Steam

Afterwards, delete the OMORI Patch folder found inside of your tmp (or temp) folder.
