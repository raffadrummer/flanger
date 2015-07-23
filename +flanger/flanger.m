function flanger( fileName )

	source = raffa.source( fileName );
	frameSize = source.SamplesPerFrame;

	Dmax = 0;
	filterParam( 1 ).Name = 'Delay max (msec)';
	filterParam( 1 ).Type = 'slider';
	filterParam( 1 ).InitialValue = Dmax;
	filterParam( 1 ).Limits = [ 0, 20 ];

	Flfo = 2;
	filterParam( 2 ).Name = 'LFO freq (Hz)';
	filterParam( 2 ).Type = 'slider';
	filterParam( 2 ).InitialValue = Flfo;
	filterParam( 2 ).Limits = [ 0, 10 ];

	phi = 0;
    DmaxF = 0;
	updateFilter( [ Dmax Flfo ] )

	function updateFilter( param )
    	Dmax =  param( 1 );
    	Flfo = param( 2 );

    	phi = 2 * pi * Flfo / source.SampleRate;
    	DmaxF = ( Dmax * source.SampleRate ) / 2000;
	end

	function audioOut = filterStep( count, audioIn, oldAudioIn )
		for k = 1 : frameSize
			n = count * frameSize + k;
			d = round( DmaxF * ( 1 - cos( phi * n ) ) );
			if k > d
				audioOut( k, : ) = audioIn( k, : ) + audioIn( k - d, : );
			else
				audioOut( k, : ) = audioIn( k, : ) + oldAudioIn( frameSize + k - d, : );
			end
	   end
	end

	raffa.dspUiHelper( source, filterParam, @updateFilter, @filterStep )

end

