primord-tools
=============

Tools used to create metadata of primord rf data

Desinged to analyze the three types of files generated
by the experiment: bgdist, pylog, and pyerr.

Usage
-----

The basic usage is `primord-metadata <directive> ...`

Supported directives are
 * `metadata` - generate metadata
 * `help` - print help message


Metadata
--------

The syntax for this directive is `primord-metadata metadata <outfile> <bgdist|pyerr|pylog> <param,param,...> <files>`

 * `outfile` - file to write the output to in csv format
 * `bgdist|pyerr|pylog` - the type of file to process (only one can be specified)
 * `param,param,...` - the parameters to collect/compute (eg. `file,lines,date` for the filename, number of lines and date)
 * `files` - a space seperated list of input files



Parametes
---------

All files support these parameters
 * `file` - name of the file
 * `date` - date of data gathered
 * `lines` - number of lines in the file

The following parameters are avalible for `bgdist`
 * `has_mulit` - whether the data has multi-frequency data
 * `stat_sf_aic` - the Akaike Information Criterion for the single frequency model
 * `stat_sf_intercept` - the count intercept used in the single frequency model
 * `stat_mf_aic` - the Akaike Information Criterion for the single frequency model
 * `stat_mf_intercept` - the count intercept used in the multi frequency model
 * `stat_sf_count` - number of single frequency events observed
 * `stat_mf_count` - number of multi frequency events observed

The following parameters are avalible for `pylog`

The following parameters are avalible for `pyerr`


BGDist Model
------------

The background noise should follow a poisson distribution. This is no suprise, as
many random processes follow this distribution. Due to hardware limitations of the
windowed FFT as well as bandwidth limitations between the USRP2 and the computer
logging the data, signals below a threshold were not logged. This makes computing
the poisson PDF for the data slightly more chalenging. The method that is employed
is a zero inflated GLM using a logarithmic link function. 





