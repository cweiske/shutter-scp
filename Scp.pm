#! /usr/bin/env perl
###################################################
#
#  Copyright (C) 2012 Christian Weiske <cweiske@cweiske.de>
#
#  This file is part of Shutter.
#
#  Shutter is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  Shutter is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Shutter; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

package Scp;

use lib $ENV{'SHUTTER_ROOT'}.'/share/shutter/resources/modules';

use utf8;
use strict;
use POSIX qw/setlocale/;
use Locale::gettext;
use Glib qw/TRUE FALSE/; 

use Shutter::Upload::Shared;
our @ISA = qw(Shutter::Upload::Shared);

my $d = Locale::gettext->domain("shutter-upload-plugins");
$d->dir( $ENV{'SHUTTER_INTL'} );

my %upload_plugin_info = (
    'module'       => "Scp",
    'url'          => "",
    'registration' => "",
    'description'  => $d->get( "Copy photos via scp. Use user as remote path, password as URL base" ),
    'supports_anonymous_upload'  => FALSE,
    'supports_authorized_upload' => TRUE,
);

binmode( STDOUT, ":utf8" );
if ( exists $upload_plugin_info{$ARGV[ 0 ]} ) {
	print $upload_plugin_info{$ARGV[ 0 ]};
	exit;
}

###################################################

sub new {
	my $class = shift;

	#call constructor of super class (host, debug_cparam, shutter_root, gettext_object, main_gtk_window, ua)
	my $self = $class->SUPER::new( shift, shift, shift, shift, shift, shift );

	bless $self, $class;
	return $self;
}

sub init {
	my $self = shift;
        use URI::Escape;
	return TRUE;
}

sub upload {
	my ( $self, $upload_filename, $username, $password ) = @_;

	#store as object vars
	$self->{_filename} = $upload_filename;

	utf8::encode $upload_filename;
	utf8::encode $password;
	utf8::encode $username;

        $upload_filename =~ m/\/([^\/]*$)/;
        my $file = $1;

        my $target_filename = $username . "/" . $file;
        $target_filename =~ s/ /\\ /g;

        my @args = ("scp", $upload_filename, $target_filename);
        system(@args);
        if ($? == 0) {
            #status: success
            $self->{_links}{'status'} = 200;
            $self->{_links}{'url'} = $password . uri_escape($file);
        } else {
            #status: error
            $self->{_links}{'status'} = "exec failed: @args / $?";
        }
	#and return links
	return %{ $self->{_links} };
}

1;
