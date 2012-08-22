*************************
Shutter scp upload plugin
*************************
Copies a file via ``scp`` to a remote server and gives you the HTTP URL.

This is an upload plugin for Shutter__.

__ http://shutter-project.org/

=====
Setup
=====
0. Copy ``Scp.pm`` to ``/usr/share/shutter/resources/system/upload_plugins/upload/``
1. In the Shutter preferences, go to the upload tab and configure the username
   and password for the Scp plugin:

   Username is the remote path you want to copy it to,
   e.g. ``example.org:screenshots/``.

   Password is the HTTP base URL to prepend before the file name,
   e.g. ``http://example.org/~user/screenshots/``

3. I expect that you have a ssh key setup, so that no password is asked.
4. That's it.


=====
Usage
=====
0. Make screenshot
1. Right-click on it, "export"
2. Select "Scp"
3. Click "Upload"


=======
License
=======
Licensed under the GPLv3 or later.


======
Author
======
Christian Weiske, cweiske@cweiske.de
