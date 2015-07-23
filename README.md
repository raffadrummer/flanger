A Matlab implementation of a flanger (and few other basic filters)
==================================================================

To use this software first checkout the repository and then add the full path
of his location to the Matlab path with the `addpath` command.

Then, run the flanger as

	flanger.flanger('test.wav')

where `test.wav` is a name of an audio file in the Matlab path;
if you provide an empty file name, a sinusoid will be played instead.

Other available filters are: `flanger.notch`, `flanger.resonator`, and `flanger.comb`.

