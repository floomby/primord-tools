Now that the visualizer is merged in everything is a total mess

There are realy only three types of files I should be pulling data from
 * log
 * pylog
 * pyerr

This is because the background distribution was generated from the logs,
just prior to my time on this project.




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
