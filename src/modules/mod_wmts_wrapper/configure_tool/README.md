# OnEarth 2 Layer WMTS/TWMS Configuration Tools

## Tools Included:

- oe2_wmts_configure.py -- Configures WMTS and TWMS endpoints for layers to be
  served in their native projection.
- oe2_reproject_configure.py -- Configures WMTS and TWMS endpoints for
  reprojected layers.

---

## oe2_wmts_configure.py

This tool creates the necessary Apache configurations to serve MRF layers via
WMTS and TWMS, using the OnEarth Apache modules (`mod_wmts_wrapper, mod_mrf, mod_twms`). It allows for both local and remote (i.e., S3) data files to be
used.

## Requirements

- Python 3.6
- OnEarth 2 modules (`mod_wmts_wrapper, mod_mrf, mod_receive, mod_twms`)
  compiled and installed.
- `mod_proxy` installed.

#### Running the tool

`oe2_wmts_configure.py endpoint_config`

This tool requires 2 configuration files to work:

- endpoint config -- contains information about how the WMTS and TWMS endpoints
  should be set up in Apache.
- layer config(s) -- contains information about each of the layers to be
  configured.

Note that Apache must be restarted for new configurations to take effect. This
command may need to be run as `sudo` depending on the permission settings for
your Apache directories.

#### How it works

This tool requires 2 different types of configuration files to work.

**Endpoint Config** -- This file sets everything up for the WMTS/TWMS endpoint for serving tiles. You'll need to configure one endpoint at a time.

**Layer Config** -- This file configures parameters for each layer to be served by the endpoint. You'll need one layer config file per layer. For convenience, you can set this to be a directory and the tool will configure all the layer configs in that directory.

#### TWMS Configurations

To create TWMS configurations, add the `twms_service` options to the endpoint config file. Example:

```
twms_service:
  internal_endpoint: "/var/www/html/twms"
  external_endpoint: "/twms"
```

#### Endpoint Configuration

The endpoint configuration should be a YAML file in the following format:

```
time_service_uri: "http://onearth-time-service/time_service/time"
layer_config_source: layer_config.yaml
apache_config_location: /etc/httpd/conf.d
gc_service_uri: "/oe2_gc_service"
wmts_service:
  internal_endpoint: "/var/www/html/wmts"
  external_endpoint: "/wmts"
  config_prefix: "oe2-wmts"
twms_service:
  internal_endpoint: "/var/www/html/twms"
  external_endpoint: "/twms"
```

##### Configuration Options:

`time_service_uri` (optional) -- OnEarth allows for the use of a time service, which performs lookups and time-snapping for tile requests. If you have time-sensitive layers, set this parameter to the URL of the time service. For more information, consult the docs for the OnEarth time service.

`layer_config_source` (required) -- This can be a path either to a single layer
configuration YAML file, or a directory containing multiple layer config files.
In the case of a directory, the tool will parse all files in that directory with
a `.yaml` extension. _Note that the tool will not recurse the contents of
subdirectories if they are present._

`base_idx_path` (optional) -- If all the IDX files for your layers are container
in a base location on disk -- and if the layer configs themselves list IDX paths
as relative paths from that location, make sure this is included. Otherwise,
leave it out. (Read on to the layer configuration section for more information.)

`apache_config_location` (optional) -- Location that the main Apache
configuration files will be stored (this will need to be somewhere Apache is
configured to read when it starts up). Defaults to `/etc/httpd/conf.d`

`time_service_keys` (optional) -- Array of keys to be used with the date
service. Keys will be positioned in the order configured.

`source_gc_uri` (optional) -- If you are using the dynamic GC/GTS service, this url should point there.

**wmts_service options**

- `internal_endpoint` -- Location on disk where all the configuration files for the WMTS layers should be stored
- `external_endpoint` -- Relative URL that the endpoint should appear at. The configuration tool will automatically build `Alias` configurations.
- `config_prefix` -- Filename prefix to be used for the Apache config that's generated.

**twms_service options**

- `internal_endpoint` -- Location on disk where all the configuration files for the TWMS layers should be stored
- `external_endpoint` -- Relative URL that the endpoint should appear at. The configuration tool will automatically build `Alias` configurations.

**Note that the configuration tool will only configure a TWMS endpoint if the `twms_service` block is configured.**

#### Layer Configuration

The layer configurations contain all the necessary information for each layer
you intend to make accessible. They should be a YAML file in the following
format:

```
layer_id: "AMSR2_Snow_Water_Equivalent"
static: true
tilematrixset: "EPSG4326_2km"
source_mrf:
  size_x: 8192
  size_y: 4096
  bands: 3
  tile_size_x: 512
  tile_size_y: 512
  idx_path: "static_test.idx"
  data_file_uri: "http://127.0.0.1/data/static_test.pjg"
  year_dir: false
  bbox: -180,-90,180,90
mime_type: "image/jpeg"
```

### Configuration Options

`layer_id` (required) -- This is the layer name string that be used for
WMTS/TWMS requests.

`static` (optional) -- Indicates whether or not the layer allows for the TIME
dimension. Defaults to 'false'.

`tilematrixset` (required) -- The name of the Tile Matrix Set to be used with
this layer.

`source_mrf` (required) -- Subsection with information about the source MRF for
this layer.

`size_x` (required) -- MRF width in pixels.

`size_y` (required) -- MRF height in pixels.

`bands` (required) -- Number of bands in the MRF imagery. (JPEG usually 3, PNG
usually 4)

`tile_size_x` (required) -- Width of each tile in pixels.

`tile_size_y` (required) -- Height of each tile in pixels.

`idx_path` (required) -- Path on disk to this layer's IDX file. If the endpoint
configuration contains a `base_idx_path`, this path will be assumed to be
relative to that path.

`data_file_path` (optional) -- Path on disk to this layer's MRF data file.

`data_file_uri` (optional) -- Remote URI to this layer's MRF data file. If this
layer has a TIME dimension, just enter the path of the data file up to the year
directory (if it has one). `mod_wmts_wrapper` will calculate the filename using
the date service.

`year_dir` (optional) -- For dynamic layers, if the data and IDX files are
contianed in separate directories by year, set this to 'true'. This will cause
the OnEarth modules to append the year of the requested tile to the path of the
IDX and data files when they are accessed. Defaults to 'false'.

`bbox` (required for TWMS) -- Bounding box of the source MRF in the projection's
native units.

`mime_type` (required) -- MIME type of the tiles in this MRF.

Example: `time_service_keys: ["epsg4326", "std"]` will cause date lookups for
this layer to use the following format:
`{time_service_uri}/date?key1=epsg4326&key2=std`

---

## oe2_reproject_configure.py

This script creates WMTS and TWMS endpoints that use `mod_reproject` to
reproject imagery.

## Requirements

- Python 3.6
- OnEarth 2 modules (`mod_wmts_wrapper, mod_reproject, mod_receive, mod_twms`)
  compiled and installed.
- `mod_proxy` installed.

## Source Imagery

`mod_reproject` is designed to reproject tiles that are already available via a
WMTS endpoint. **It does not use MRFs!** If you want to reproject MRFs, first
use `oe2_wmts_configure.py` to make those MRFs available via a WMTS endpoint.

Note that this configuration tool uses the GetCapabilities file of a WMTS
endpoint to create its configurations.

#### Running the tool

`oe2_reproject_configure.py endpoint_config {--tms_defs}`

This tool requires configuration files to work:

- endpoint config -- contains information about how the WMTS and TWMS endpoints
  should be set up in Apache.

Note that Apache must be restarted for new configurations to take effect. This
command may need to be run as `sudo` depending on the permission settings for
your Apache directories.

#### Tile Matrix Set definitions

This tool requires an XML Tile Matrix Set definitions file in order to work. A
file including the most commonly used Tile Matrix Sets is included
(`tilematrixsets.xml`), which this tool uses by default. The `--tms_defs` option
can be used to point the tool to a different file.

#### Endpoint Configuration

The endpoint configuration should be a YAML file in the following format:

```
time_service_uri: "http://onearth-time-service/time_service/time"
target_epsg_code: "EPSG:3857"
source_gc_uri: "https://gibs.earthdata.nasa.gov/wmts/epsg4326/best/1.0.0/WMTSCapabilities.xml"
tms_defs_file: "/etc/oe2/tilematrixsets.xml"
gc_service_uri: "/oe2_gc_service"
include_layers:
  - 'AMSR2_Cloud_Liquid_Water_Day'
  - 'AMSR2_Cloud_Liquid_Water_Night'
  - 'BlueMarble_NextGeneration'
layer_config_source: layer_config.yaml
base_uri_gc: 'http://some-uri/'
wmts_service:
  internal_endpoint: "/var/www/html/wmts"
  external_endpoint: "/wmts"
  config_prefix: "oe2-wmts-reproject"
twms_service:
  internal_endpoint: "/var/www/html/twms"
  external_endpoint: "/twms"
```

##### Configuration Options:

`time_service_uri` (optional) -- If you are using dynamic layers, put the URL of
the OnEarth 2 date service here.

`apache_config_location` (optional) -- Location that the main Apache
configuration files will be stored (this will need to be somewhere Apache is
configured to read when it starts up). Defaults to `/etc/httpd/conf.d`

`time_service_keys` (optional) -- Array of keys to be used with the date
service. Keys will be positioned in the order configured.

`gc_service_uri` (optional) -- If you are using the dynamic GC/GTS service, this url should point there.

`target_epsg_code` (required) -- The projection that your source imagery will be
reprojected to. Note that this projection must have Tile Matrix Sets configured
in the Tile Matrix Set definition file.

`tms_defs_file` (optional) -- If using a Tile Matrix Sets file different from
the one bundled with the script, you can define it here instead of using the
command line parameter.

**wmts_service options**

- `internal_endpoint` -- Location on disk where all the configuration files for the WMTS layers should be stored
- `external_endpoint` -- Relative URL that the endpoint should appear at. The configuration tool will automatically build `Alias` configurations.
- `config_prefix` -- Filename prefix to be used for the Apache config that's generated.

**twms_service options**

- `internal_endpoint` -- Location on disk where all the configuration files for the TWMS layers should be stored
- `external_endpoint` -- Relative URL that the endpoint should appear at. The configuration tool will automatically build `Alias` configurations.
