# building a buffer shape for filtering the weather data
import geopandas
from shapely.ops import cascaded_union

leipzig = geopandas.read_file("./assets/ot.shp")
leipzig = leipzig.to_crs("epsg:3857")
leipzig_boundary = geopandas.GeoDataFrame(geopandas.GeoSeries(cascaded_union(leipzig['geometry'])))
leipzig_boundary = leipzig_boundary.rename(columns={0:'geometry'}).set_geometry('geometry')

leipzig_buffer = leipzig_boundary.buffer(2000)
leipzig_buffer = leipzig_buffer.simplify(1000)

leipzig_buffer = geopandas.GeoDataFrame(leipzig_buffer)
leipzig_buffer = leipzig_buffer.rename(columns={0:'geometry'}).set_geometry('geometry')
leipzig_buffer.crs = "epsg:3857"
leipzig_buffer.to_file("./assets/buffer.shp")
