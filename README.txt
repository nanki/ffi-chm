= ffi-chm

* http://github.com/nanki/ffi-chm

== DESCRIPTION:

Ruby bindings for the libchm via FFI.

== FEATURES/PROBLEMS:

* Provides basic access to the CHM files.
* Some functionalities to access to internal structure.
* Fulltext search.
* Currently developed on MRI 1.8.7 / 1.9.2

== SYNOPSIS:

  FFI::Chm::ChmFile.new("reference-manual.chm") do |chm|
    chm.enumerate(:normal, :files).map{|ui| ui[:path]}

    puts chm.title
  end

== REQUIREMENTS:

* Ruby
* libffi
* libchm
* Nokogiri >= 1.5.0

== INSTALL:

  $ gem install ffi-chm

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2011 NANKI Haruo

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
