#!/bin/sh
REDIS_HOST=gitc-jrod-redis.4fest7.ng.0001.use1.cache.amazonaws.com

if [ ! -f /.dockerenv ]; then
  echo "This script is only intended to be run from within Docker" >&2
  exit 1
fi

# Copy config stuff
mkdir -p /var/www/html/mrf_endpoint/static_test/default/tms
cp test_imagery/static_test* /var/www/html/mrf_endpoint/static_test/default/tms/
cp oe2_test_mod_mrf_static.conf /etc/httpd/conf.d
cp layer_configs/oe2_test_mod_mrf_static_layer.config /var/www/html/mrf_endpoint/static_test/default/tms/

mkdir -p /var/www/html/mrf_endpoint/date_test/default/tms
cp test_imagery/date_test* /var/www/html/mrf_endpoint/date_test/default/tms
cp oe2_test_mod_mrf_date.conf /etc/httpd/conf.d
cp layer_configs/oe2_test_mod_mrf_date_layer.config /var/www/html/mrf_endpoint/date_test/default/tms/

mkdir -p /var/www/html/mrf_endpoint/date_test_year_dir/default/tms/{2015,2016,2017}
cp test_imagery/date_test_year_dir1420070400* /var/www/html/mrf_endpoint/date_test_year_dir/default/tms/2015
cp test_imagery/date_test_year_dir1451606400* /var/www/html/mrf_endpoint/date_test_year_dir/default/tms/2016
cp test_imagery/date_test_year_dir1483228800* /var/www/html/mrf_endpoint/date_test_year_dir/default/tms/2017
cp oe2_test_mod_mrf_date_year_dir.conf /etc/httpd/conf.d
cp layer_configs/oe2_test_mod_mrf_date_layer_year_dir.config /var/www/html/mrf_endpoint/date_test_year_dir/default/tms/

mkdir -p /var/www/html/reproject_endpoint/date_test/default/tms
cp oe2_test_mod_reproject_date.conf /etc/httpd/conf.d
cp layer_configs/oe2_test_mod_reproject_layer_source*.config /var/www/html/reproject_endpoint/date_test/default/tms/oe2_test_mod_reproject_date_layer_source.config
cp layer_configs/oe2_test_mod_reproject_date*.config /var/www/html/reproject_endpoint/date_test/default/tms/

mkdir -p /var/www/html/reproject_endpoint/static_test/default/tms
cp oe2_test_mod_reproject_static.conf /etc/httpd/conf.d
cp layer_configs/oe2_test_mod_reproject_layer_source*.config /var/www/html/reproject_endpoint/static_test/default/tms/oe2_test_mod_reproject_static_layer_source.config
cp layer_configs/oe2_test_mod_reproject_static*.config /var/www/html/reproject_endpoint/static_test/default/tms/

# GIBS sample configs

mkdir -p /var/www/html/reproject_endpoint/BlueMarble/default/500m/
cp layer_configs/BlueMarble_reproject.config /var/www/html/reproject_endpoint/BlueMarble/default/500m/
cp layer_configs/BlueMarble_source.config /var/www/html/reproject_endpoint/BlueMarble/default/500m//

mkdir -p /var/www/html/mrf_endpoint/BlueMarble/default/500m/
wget -O /var/www/html/mrf_endpoint/BlueMarble/default/500m/BlueMarble.idx https://s3.amazonaws.com/gitc-test-imagery/BlueMarble.idx
cp layer_configs/BlueMarble.config /var/www/html/mrf_endpoint/BlueMarble/default/500m/

mkdir -p /var/www/html/mrf_endpoint/MOGCR_LQD_143_STD/default/250m/
wget -O /var/www/html/mrf_endpoint/MOGCR_LQD_143_STD/default/250m/MOG13Q4_LQD_NDVI_NRT1514764800.idx https://s3.amazonaws.com/gitc-test-imagery/MOG13Q4_LQD_NDVI_NRT1514764800.idx
cp layer_configs/MOGCR_LQD_143_STD.config /var/www/html/mrf_endpoint/MOGCR_LQD_143_STD/default/250m/

mkdir -p /var/www/html/mrf_endpoint/VNGCR_LQD_I1-M4-M3_NRT/default/250m/2018
wget -O /var/www/html/mrf_endpoint/VNGCR_LQD_I1-M4-M3_NRT/default/250m/VNGCR_LQD_I1-M4-M3_NRT.idx https://s3.amazonaws.com/gitc-test-imagery/VNGCR_LQD_I1-M4-M3_NRT.idx
d=1516060800
until [ $d -gt 1524614400 ]; do
    ln -s /var/www/html/mrf_endpoint/VNGCR_LQD_I1-M4-M3_NRT/default/250m/VNGCR_LQD_I1-M4-M3_NRT.idx /var/www/html/mrf_endpoint/VNGCR_LQD_I1-M4-M3_NRT/default/250m/2018/VNGCR_LQD_I1-M4-M3_NRT$d.idx
    let d+=86400
done
cp layer_configs/VNGCR_LQD_I1-M4-M3_NRT*.config /var/www/html/mrf_endpoint/VNGCR_LQD_I1-M4-M3_NRT/default/250m/

mkdir -p /var/www/html/mrf_endpoint/MOG13Q4_LQD_NDVI_NRT/default/250m/2018
wget -O /var/www/html/mrf_endpoint/MOG13Q4_LQD_NDVI_NRT/default/250m/MOG13Q4_LQD_NDVI_NRT.idx https://s3.amazonaws.com/gitc-test-imagery/MOG13Q4_LQD_NDVI_NRT.idx
d=1514764800
until [ $d -gt 1523318400 ]; do
    ln -s /var/www/html/mrf_endpoint/MOG13Q4_LQD_NDVI_NRT/default/250m/MOG13Q4_LQD_NDVI_NRT.idx /var/www/html/mrf_endpoint/MOG13Q4_LQD_NDVI_NRT/default/250m/2018/MOG13Q4_LQD_NDVI_NRT$d.idx
    let d+=86400
done
cp layer_configs/MOG13Q4_LQD_NDVI_NRT.config /var/www/html/mrf_endpoint/MOG13Q4_LQD_NDVI_NRT/default/250m/

# AST_L1T sample configs

cp oe2_test_AST_L1T.conf /etc/httpd/conf.d

mkdir -p /var/www/html/wmts/epsg3857/all/ASTER_L1T_Radiance_Terrain_Corrected/default/GoogleMapsCompatible_Level13
mkdir -p /var/www/html/wmts/epsg3857/best/ASTER_L1T_Radiance_Terrain_Corrected/default/GoogleMapsCompatible_Level13
mkdir -p /var/www/html/wmts/epsg3857/std/ASTER_L1T_Radiance_Terrain_Corrected/default/GoogleMapsCompatible_Level13
mkdir -p /var/www/html/wmts/epsg4326/all/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016
mkdir -p /var/www/html/wmts/epsg4326/best/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016
mkdir -p /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016
mkdir -p /var/www/html/twms/epsg4326/configs/ASTER_L1T_Radiance_Terrain_Corrected
mkdir -p /var/www/html/twms/epsg3857/configs/ASTER_L1T_Radiance_Terrain_Corrected
mkdir -p /var/www/html/wmts/epsg4326/configs
mkdir -p /var/www/html/wmts/epsg3857/configs

cp layer_configs/ASTER_L1T_Radiance_Terrain_Corrected.config /var/www/html/wmts/epsg4326/configs/
cp layer_configs/ASTER_L1T_Radiance_Terrain_Corrected_source.config /var/www/html/wmts/epsg3857/configs/
cp layer_configs/ASTER_L1T_Radiance_Terrain_Corrected_reproject.config /var/www/html/wmts/epsg3857/configs/
cp layer_configs/ASTER_L1T_Radiance_Terrain_Corrected_4326_twms.config /var/www/html/twms/epsg4326/configs/ASTER_L1T_Radiance_Terrain_Corrected/twms.config
cp layer_configs/ASTER_L1T_Radiance_Terrain_Corrected_3857_twms.config /var/www/html/twms/epsg3857/configs/ASTER_L1T_Radiance_Terrain_Corrected/twms.config

wget -O /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx https://s3.amazonaws.com/gitc-test-imagery/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx
wget -O /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx https://s3.amazonaws.com/gitc-test-imagery/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx
wget -O /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx https://s3.amazonaws.com/gitc-test-imagery/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx
ln -s /var/www/html/wmts/epsg4326/best/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx
ln -s /var/www/html/wmts/epsg4326/all/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555106.idx
ln -s /var/www/html/wmts/epsg4326/best/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx
ln -s /var/www/html/wmts/epsg4326/all/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555115.idx
ln -s /var/www/html/wmts/epsg4326/best/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx
ln -s /var/www/html/wmts/epsg4326/all/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx /var/www/html/wmts/epsg4326/std/ASTER_L1T_Radiance_Terrain_Corrected/default/15.625m/2016/ASTER_L1T_Radiance_Terrain_Corrected1480555124.idx

echo 'Starting Apache server'
/usr/sbin/apachectl
sleep 2

# Add some test data to redis for profiling
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:date_test
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:date_test:default "2015-01-01"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:date_test:periods "2015-01-01/2017-01-01/P1Y"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:date_test_year_dir
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:date_test_year_dir:default "2015-01-01"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:date_test_year_dir:periods "2015-01-01/2017-01-01/P1Y"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:MOGCR_LQD_143_STD
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:MOGCR_LQD_143_STD:default "2011-01-01"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:MOGCR_LQD_143_STD:periods "2011-01-01/2011-01-02/P1D"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:VNGCR_LQD_I1-M4-M3_NRT
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:VNGCR_LQD_I1-M4-M3_NRT:default "2018-01-16"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:VNGCR_LQD_I1-M4-M3_NRT:periods "2018-01-16/2019-01-16/P1D"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:MOG13Q4_LQD_NDVI_NRT
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:MOG13Q4_LQD_NDVI_NRT:default "2018-01-01"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:MOG13Q4_LQD_NDVI_NRT:periods "2018-01-01/2019-01-01/P1D"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 DEL layer:ASTER_L1T_Radiance_Terrain_Corrected
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SET layer:ASTER_L1T_Radiance_Terrain_Corrected:default "2016-12-01T01:18:44Z"
/usr/bin/redis-cli -h $REDIS_HOST -n 0 SADD layer:ASTER_L1T_Radiance_Terrain_Corrected:periods "2016-12-01T01:18:26Z/2019-01-01T00:00:01Z/PT1S"

# AST L1T sample dates


# /usr/bin/redis-cli -h $REDIS_HOST -n 0 SAVE

# Tail the apache logs
exec tail -qF \
  /etc/httpd/logs/access.log \
  /etc/httpd/logs/error.log \
  /etc/httpd/logs/access_log \
  /etc/httpd/logs/error_log