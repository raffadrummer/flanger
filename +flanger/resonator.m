function resonator( fileName )

	source = flanger.source( fileName );

	Kind = 1;
	filterParam( 1 ).Name = 'Kind';
	filterParam( 1 ).Type = 'dropdown';
	filterParam( 1 ).Values = { 'Zeros at origin', 'Zeros on unit circumference' };
	filterParam( 1 ).InitialValue = Kind;

	F0 = 440 * 2^3;
	filterParam( 2 ).Name = 'F0';
	filterParam( 2 ).Type = 'slider';
	filterParam( 2 ).InitialValue = F0;
	filterParam( 2 ).Limits = [ 1, source.SampleRate / 2 ];

	r = 0.8;
	filterParam( 3 ).Name = 'r';
	filterParam( 3 ).Type = 'slider';
	filterParam( 3 ).InitialValue = r;
	filterParam( 3 ).Limits = [ 0, 0.9999 ];

	fig = figure();

	a = [];
	b = [];
	status = [];
	updateFilter( [ Kind F0 r ] );

	function updateFilter( param )
		Kind = param( 1 );
		F0 = param( 2 );
		r = param( 3 );

		w0 = 2 * pi * F0 / source.SampleRate;
		a = [ 1, -2 * r * cos( w0 ), r * r ];
		if Kind == 1
			b = [ 1 ];
		else
			b = [ 1 0 -1 ];
		end
		b = b / abs( evalfr( tf( b, a, -1 ), exp( i * w0 ) ) );
		status = [];

		[ H, w ] = freqz( b, a );
		plot( w * ( source.SampleRate / ( 2 * pi ) ), abs( H ) );
		hold on;
		plot( [ w0  w0 ] * ( source.SampleRate / ( 2 * pi ) ), [ 0 1 ] );
		if Kind == 1
			wr = real( acos( ( ( 1 + r * r ) / ( 2 * r ) ) * cos( w0 ) ) );
			Hwr = abs( evalfr( tf( b, a, -1 ), exp( i * wr ) ) );
			plot( [ wr  wr ] * ( source.SampleRate / ( 2 * pi ) ), [ 0 Hwr ] );
			legend( '|H(\omega)|', '\omega_0', '\omega_r' );
		else
			legend( '|H(\omega)|', '\omega_0' );
		end
		hold off;
	end

	function audioOut = filterStep( count, audioIn, oldAudioIn )
		[ audioOut, status ] = filter( b, a, audioIn, status );
	end

	flanger.dspUiHelper( source, filterParam, @updateFilter, @filterStep )

	close( fig );
end
