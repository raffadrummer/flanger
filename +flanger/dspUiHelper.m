function dspUiHelper( source, filterParam, updateFilter, filterStep )

	% http://www.mathworks.com/examples/matlab-dsp-system/2371-introduction-to-streaming-signal-processing-in-matlab

	source.SamplesPerFrame = 1024;


	FswP = -1;

	if isa( source, 'dsp.SineWave' )
		FswP = length( filterParam ) + 1;
		Fsw = source.Frequency;
		filterParam( FswP ).Name = 'SineWave F';
		filterParam( FswP ).Type = 'slider';
		filterParam( FswP ).InitialValue = Fsw;
		filterParam( FswP ).Limits = [ 1, source.SampleRate / 2 ];
	end

	AP = dsp.AudioPlayer( 'SampleRate', source.SampleRate );
	SA = dsp.SpectrumAnalyzer( 'PlotAsTwoSidedSpectrum', false, 'SampleRate', source.SampleRate );

	hUI = HelperCreateParamTuningUI( filterParam, 'DspUI' );
	while true %workaround
		[ param, button ] = HelperUnpackUDP();
		if ~button.stopSim
			break;
		end
	end

	count = 0;
	audioIn = zeros( source.SamplesPerFrame, 2 );
	while ~button.stopSim
		[ param, button ] = HelperUnpackUDP();
	    if button.pauseSim
	    	pause( source.SamplesPerFrame / source.SampleRate )
	        continue;
	    end
	    if ~isempty( param )
	    	updateFilter( param );
	    	if FswP > 0
				Fsw = param( FswP );
				release( source );
	    		source.Frequency = Fsw;
	    	end
	    end
	    oldAudioIn = audioIn;
	    audioIn = step( source );
	    audioOut = filterStep( count, audioIn, oldAudioIn );
	    step( SA, audioOut );
	    step( AP, audioOut );
	    count = count + 1;
	end

	release( AP );
	release( SA );
	delete( hUI );

end

