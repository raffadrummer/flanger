function comb( fileName )

	source = flanger.source( fileName );

	Kind = 1;
	filterParam( 1 ).Name = 'Kind';
	filterParam( 1 ).Type = 'dropdown';
	filterParam( 1 ).Values = { 'FIR', 'IIR' };
	filterParam( 1 ).InitialValue = Kind;

	M = 2;
	filterParam( 2 ).Name = 'M';
	filterParam( 2 ).Type = 'slider';
	filterParam( 2 ).InitialValue = M;
	filterParam( 2 ).Limits = [ 1, 100 ];

	g = .9;
	filterParam( 3 ).Name = 'g';
	filterParam( 3 ).Type = 'slider';
	filterParam( 3 ).InitialValue = g;
	filterParam( 3 ).Limits = [ 0, 10 ];

	fig = figure();

	a = [];
	b = [];
	status = [];
	updateFilter( [ Kind M g ] );

	function updateFilter( param )
		Kind = param( 1 );
		M = round( param( 2 ) );
		g = param( 3 );

		if Kind == 1
			a = [ 1 ];
			b = [ 1 zeros( 1, M - 1 ) g ];
		else
			a = [ 1  -1 ] * ( M + 1 );
			g = -1;
			b = [ 1 zeros( 1, M ) 1 ];
		end

		status = [];

		[ H, w ] = freqz( b, a );
		plot( w * ( source.SampleRate / ( 2 * pi ) ), abs( H ) );
	end

	function audioOut = filterStep( count, audioIn, oldAudioIn )
		[ audioOut, status ] = filter( b, a, audioIn, status );
	end

	flanger.dspUiHelper( source, filterParam, @updateFilter, @filterStep )

	close( fig );
end
