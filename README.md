# R Arc JSON

An R script designed to pull and process JSON output from an arcGIS REST API.
Originally designed for use with the DHS Spatial Repository.

## To use dhsQuery

```
source("https://raw.githubusercontent.com/akmiller01/r_arc_json/master/arc_json.R")
eg.query = "DHSCC in ('AF') AND SVYTYPE in ('DHS') AND SVYYEAR > 2010"
afg.dhs = dhsQuery(eg.query)
plot(afg.dhs)
```

## To use in general

```
source("https://raw.githubusercontent.com/akmiller01/r_arc_json/master/arc_json.R")
url = "https://gis.dhsprogram.com/arcgis/rest/services/Geometry/SDR_Regions/MapServer/0/query?f=json&where=DHSCC+in+%28%27AF%27%29+AND+SVYTYPE+in+%28%27DHS%27%29+AND+SVYYEAR+>+2010&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=DHSCC%2CCNTRYNAMEE%2CSVYTYPE%2CSVYYEAR%2CDHSREGEN%2CREGNOTES%2COBJECTID%2CSVYNOTES%2CSVYID%2CLEVELRNK%2CLEVELNA%2CColorAdjust%2CSvy_Map%2CSTATCOM%2CNATL_DATA&returnGeometry=true&returnTrueCurves=false&maxAllowableOffset=&geometryPrecision=&outSR=4326&returnIdsOnly=false&returnCountOnly=false&orderByFields=SVYYEAR%2CSVYTYPE%2CSVYID%2CLEVELRNK&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&resultOffset=&resultRecordCount="
obj.id.var = "OBJECTID"
afg.dhs = arcJson(url, obj.id.var)
```

## Note

For the moment, this only parses ring geometry, as this is the only type the DHS Spatial Repository seems to return.
In the future, it may be useful to add parsing functionality for additional types of geometry. 
