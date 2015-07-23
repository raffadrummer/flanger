function S = source( fileName )
	if isempty( fileName )
		S = dsp.SineWave;
		S.Frequency = 440;
		S.SampleRate = 44100;
	else
		S = dsp.AudioFileReader( 'Filename', fileName );
		S.PlayCount = 100;
	end
end
