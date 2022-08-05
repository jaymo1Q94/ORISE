#Coordinate reference systems ####

#Earth uses an angular coordinate system indicated by longitude and latitude
#latitude is mathematically denoted as phi and longitude is denoted as lambda

#Since we can't actually calculate the geometric angles of the planet Earth,
#we can use geographic models called datum or "geodesic datum" to estimate
#reference calculations for precise locations 

#Datum exist at the planetary, continental, regional, etc...levels to help
#focus more precise locations in smaller reference areas

#Projections can be used to transform 3D spatial models into 2D planar models
#This opens up calculations on a cartesian plane for geometric algebra
#This is also good for map building 

#The CRS Notation is made up of the projection, datum, and set of parameters 

#So our current CRS is using the WGS84 datum, with a mercator projections,
#with our paramaters set to our dataframe dimensions, resolution, 
#spatial extent (longitude and latitude), crs slot input 

#last note - proj4 is the name of an open-source reference library
#that R queries when retrieving and displaying CRS data and each 
#CRS has a unique ID or ESPG (European Petroleum Survey Group) code
#that can be used within a database but has no real standard meaning
#outside of the programming environment 


#Searching for a Projection ####


epsg <- make_EPSG()

head(epsg)

View(epsg)

#So this is pulling out a character vector containing 
#observations in the note variable that match the "France" argument pattern
#without concern for upper or lower case spelling 

i <- grep("France", epsg$note, ignore.case = T)

#Example Data Set #

f <- system.file("external/lux.shp", package="raster")
p <- shapefile(f)
p

#This is a spatialpolygondataframe (map data?)

showDefault(p)

#The CRS function will allow us to check the CRS of our spatial object p

#We can add or remove CRSes as necessary 

pp <- p

crs(pp) <- NA #again we can do this because this is a dataframe object class

pp

crs(pp)

#Now set the CRS with the CRS function 

crs(pp) <- CRS("+proj=longlat +datum=WGS84")

crs(pp)

#So we just removed and inserted a CRS system, again most 
#spatial files we work with will have a CRS pre-defined 

#Data Transformation of Spatial Vectors ###

#Create a new spatial data object with the robin projection for the CS 

newcrs <- CRS("+proj=robin +datum=WGS84")

rob <- spTransform(p, newcrs)

rob
#We can also backtransform one projection to another 

p2 <- spTransform(rob, CRS("+proj=longlat +datum=WGS84"))

p2

#Same values different map projection between rob and p2 

#Visualizing Raster Data Transformations #####

r <- raster(xmn = -110, xmx = -90, ymn = 40, ymx = 60, ncols = 40, nrows = 40)

r <- setValues(r, 1:ncell(r))

r

plot(r)

#new projection 

newproj <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 + ellps=WGS84"

#Simple Approach to Raster Data Transformation 

pr1 <- projectRaster(r, crs = newproj)

crs(pr1)

#set resolution 

#1 - use project raster and set the res as an argument

pr2 <- projectRaster(r, crs = newproj, res= 20000)

pr2

#2 create the spatial extent for a new raster file 
#input the resolution value as a variable 

pr3 <- projectExtent(r, newproj)

res(pr3) <- 20000

#Now we can project the raster to finish the raster file transformation 

pr3 <- projectRaster(r, pr3)

pr3

plot(pr3)

#The tutorial shows an uneven grid for the spatial projections
#but ours doesn't. Either way, the lesson being that unequal
#grid lines on a plot indicate that the projections do not have
#equal area 


#####
