# geospatial_analysis
Repository containing various geospatial functions in both python and R.
The following functions are present at the moment:

1. A function to calculate network-based (rather than Euclidean) minimum distance between two sets of points (origins and destinations) in a relatively short time by using as input:
    1. The actual road network. The function scales with the dimension of the road network, rather than the number of points. This is to avoid excessive duration of the computation as the function was written to deal with datasets with a considerable number of points (e.g. >10,000)
    2. The origin points, uploaded as sf file
    3. The destination points, also an sf file
    4. The name of the output column (e.g. distance from metro/bus/hospital etc)
3. 
