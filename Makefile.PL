use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		   => 'Net::Netflix',
    'VERSION_FROM' => 'lib/Net/Netflix.pm',
    'PREREQ_PM'    => {
		'WWW::Mechanize'      => 0.59
	}, 
    ($] >= 5.005 ? ( AUTHOR => 'John Resig <jeresig@gmail.com>') : ()),
);
