list.of.packages <- c("jsonlite","data.table","sp","rgdal","rgeos","spdep")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

ring2poly = function(ring){
  ring.dim = dim(ring)
  if(length(ring.dim)==3){
    point.len = ring.dim[2]
    x1 = ring[1,c(1:point.len),1]
    y1 = ring[1,c(1:point.len),2] 
  }else{
    point.len = ring.dim[1]
    x1 = ring[c(1:point.len),1]
    y1 = ring[c(1:point.len),2]
  }
  c1 = cbind(x1, y1)
  r1 = rbind(c1, c1[1, ])
  P1 = Polygon(r1)
  return(P1)
}

arcJson = function(url, idname){
  message("Getting data from API...")
  tmp = tempfile()
  download.file(url, tmp)
  arc_json_data = fromJSON(tmp)
  if("error" %in% names(arc_json_data)){
    stop(paste(arc_json_data$error$message, arc_json_data$error$details,sep=": "))
  }
  message("Data successfully read. Processing...")
  poly.list = list()
  attrib.list = list()
  for(i in 1:length(arc_json_data["features"][[1]][["geometry"]][["rings"]])){
    ring = arc_json_data["features"][[1]][["geometry"]][["rings"]][[i]]
    attribs = arc_json_data['features'][[1]]["attributes"][[1]][i,]
    message("Country: ", attribs$CNTRYNAMEE,"; Year: ", attribs$SVYYEAR,"; Region: ", attribs$DHSREGEN,"; Level: ", attribs$LEVELRNK)
    attrib.list[[i]] = attribs
    if(typeof(ring)=="double"){
      P1 = ring2poly(ring)
      Ps1 = Polygons(list(P1), ID = attribs[idname][[1]])
      poly.list[[i]] = Ps1
    }else{
      subpoly.list = list()
      for(j in 1:length(ring)){
        subring = ring[[j]]
        P1 = ring2poly(subring)
        subpoly.list[[j]] = P1
      }
      Ps1 = Polygons(subpoly.list, ID = attribs[idname][[1]])
      poly.list[[i]] = Ps1
    }
  }
  poly.dat = rbindlist(attrib.list)
  rownames(poly.dat) = poly.dat$OBJECTID
  SPs = SpatialPolygons(poly.list)
  SPDF = SpatialPolygonsDataFrame(SPs,poly.dat)
  crs.geo <- CRS("+proj=longlat +datum=WGS84")
  proj4string(SPDF) <- crs.geo
  return(SPDF)
}

dhsQuery = function(query){
  query = gsub(" ","+",query)
  query = gsub("'","%27",query)
  query = gsub("\\(","%28",query)
  query = gsub(")","%29",query)
  url = paste0(
    "https://gis.dhsprogram.com/arcgis/rest/services/Geometry/SDR_Regions/MapServer/0/query?",
    "f=json",
    "&where=",query,
    "&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=DHSCC%2CCNTRYNAMEE%2CSVYTYPE%2CSVYYEAR%2CDHSREGEN%2CREGNOTES%2COBJECTID%2CSVYNOTES%2CSVYID%2CLEVELRNK%2CLEVELNA%2CColorAdjust%2CSvy_Map%2CSTATCOM%2CNATL_DATA&returnGeometry=true&returnTrueCurves=false&maxAllowableOffset=&geometryPrecision=&outSR=4326&returnIdsOnly=false&returnCountOnly=false&orderByFields=SVYYEAR%2CSVYTYPE%2CSVYID%2CLEVELRNK&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&resultOffset=&resultRecordCount=")
  SPDF = arcJson(url,"OBJECTID")
  return(SPDF)
}

# Example
# eg.query = "DHSCC in ('AF') AND SVYTYPE in ('DHS') AND SVYYEAR > 2010"
# afg.dhs = dhsQuery(eg.query)
rm(list.of.packages)
rm(new.packages)