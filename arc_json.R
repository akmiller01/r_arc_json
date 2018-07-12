library(jsonlite)

url = "https://gis.dhsprogram.com/arcgis/rest/services/Geometry/SDR_Regions/MapServer/0/query?f=json&where=DHSCC+in+%28%27ET%27%29+AND+SVYTYPE+in+%28%27DHS%27%29&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=DHSCC%2CCNTRYNAMEE%2CSVYTYPE%2CSVYYEAR%2CDHSREGEN%2CREGNOTES%2COBJECTID%2CSVYNOTES%2CSVYID%2CLEVELRNK%2CLEVELNA%2CColorAdjust%2CSvy_Map%2CSTATCOM%2CNATL_DATA&returnGeometry=true&returnTrueCurves=false&maxAllowableOffset=&geometryPrecision=&outSR=4326&returnIdsOnly=false&returnCountOnly=false&orderByFields=SVYYEAR%2CSVYTYPE%2CSVYID%2CLEVELRNK&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&resultOffset=&resultRecordCount=&f=html"

arc_json_data = fromJSON(url)
x = arc_json_data["features"][[1]][["geometry"]][["rings"]][[1]][c(1:7156)]
y = arc_json_data["features"][[1]][["geometry"]][["rings"]][[1]][c(7157:14312)]
plot(x,y)