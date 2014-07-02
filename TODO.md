Main part
 * a good README
 * a better help message
 * option parsing
 * pyerr/pylog - parse the logs and find errors
 * cross coralate time of error to bgdist data
 * bgdist - get the threshold
 * bgdist - aggragate data in a short time periods together
 * bgdist - find data duration

On the R side of things 
 * fit poisson to data [here](http://stats.stackexchange.com/questions/70558/diagnostic-plots-for-count-regression)
   and [here](http://www.ats.ucla.edu/stat/r/dae/zipoisson.htm)
 * get it working on windows
 * caching of computed statistics to make re-running it on largish subsets of the data faster
 * bgdist - get mu and lambda

Package Issues
 * Fix up the rake file
 * rinruby is a pain so do something about it

Wishlist
 * get data in a time line
 * make a nice web ui with an interactive timeline
 * make the timeline pinable
