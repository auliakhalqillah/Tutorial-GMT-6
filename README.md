# Tutorial GMT 6

_Note: This tutorial, I write also in my blog [auliakhalqillah.com](https://auliakhalqillah.com/generate-a-simple-map-in-gmt-6/)_

## Introduction

Hi there. In this repository, we are going to learn how to generate a simple map by using GMT 6. Generic Mapping Tools (GMT) is the tool to generate a map or visual graphic based on code line. The GMT is an open-source tool and has been widely used in Earth, Ocean and Planetary fields. This tool can be used in Linux, Windows and Mac OS. For more information about this tool and how to install it to your own system, just visit https://www.generic-mapping-tools.org/download/.

In this case, the code has been tested in Linux system through the shell of csh. If you have not installed the csh yet, type the following command through the terminal

```
sudo apt-get install csh
```

## Plot a Map

<img align="center" width=458 height=550 src="https://github.com/auliakhalqillah/Tutorial-GMT-6/blob/main/Aceh.png">

The following code is a GMT code to produce a simple map with topography as shown in Figure 1 above. I will explain for each code line what that means are.

```
#!/bin/csh
 
# GMT set/configuration
gmt set MAP_FRAME_TYPE plain
gmt set PS_MEDIA 500x500
 
# Set a coordinate
# region=min longitude/max longitude/min latitude/max latitude
set region=95/97/4/6
 
# Set output file in postscript format (.ps)
set output=Aceh.ps
 
# Generate base map
gmt psbasemap -JM10/10 -R$region -Xc -Yc -Ba0.5f0.1 -BWesN+tAceh -V -K > $output
 
# Plot grid image
set grid=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrid.grd
set grad=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrad.grad 
set cpt=/mnt/d/GMT/GMTCODE/TUTORIAL/acehcolor.cpt
 
gmt grdimage $grid -I$grad -R -JM -C$cpt -K -O >> $output
 
# Generate coast line of an area
gmt pscoast -R -JM -Swhite -Df -W0.02 -LjBL+c0+w50k+f+l+o1/1 -TdjTR+w1,,,N+f1+l+o1.2/1.5 -K -O >> $output
 
# Plot a multiple symbol
awk -F',' 'NR!=1 {print $3, $2}' earthquake_aceh.csv | gmt psxy -R -JM -Sc0.5  -Wblack -Gred -K -O >> $output
 
# Plot a line
awk -F',' 'NR!=1 {print $2, $3}' aceh_segment_fault.csv | gmt psxy -R -JM -W1,blue -K -O >> $output

# author
# awk -F',' 'NR!=1 {print $3, $2-0.05, $5}' earthquake_aceh.csv | gmt pstext -R -JM -F+f14 -V -K -O >> $output 
echo "95.7 4.5 Created by Aulia Khalqillah (2021)" | gmt pstext -R -JM -Bwesn -F+f7,black -K -O >> $output

# Plot Colorbar
gmt psscale -C$cpt -Dx0c/-1.5c+w10c/0.5c+h -Bxa450f+l"Elevation" -By+lm -G0/3000 -K -O >> $output
 
# Plot Inset Map
gmt pscoast -R94/100/2/7 -JM4.0/4.0 -Bwesn -X5.9 -Y0.1 -Dh -W0.2 -G224/240/255 -Sgrey -K -O >> $output
 
# Plot square box as area sign
rm box1.dat # remove previous box1.dat
echo 95 4 > box1.dat
echo 97 4 >> box1.dat
echo 97 6 >> box1.dat
echo 95 6 >> box1.dat
echo 95 4 >> box1.dat
gmt psxy box1.dat -R -JM -W0.8,red -O >> $output

# Export ps to png file
gmt psconvert $output -A -P -Tg
```

## What is #!/bin/csh ?

The `#!/bin/csh` is a command to call csh's shell compiler that we use to compile this script. This command is always written at the first line. You can use other options to compile this code, such as by using `bash`, `tcsh` or `sh` command.

## GMT Map Configuration

In GMT, we can configure what kind of a map style that we want, such as paper size, font style and many more. For example in this code, I configure the paper size of 500x500 (in cm) and frame of map is palin mode as follows

```
# GMT set/configuration
gmt set MAP_FRAME_TYPE plain
gmt set PS_MEDIA 500x500
```

don't forget to write the `gmt set [CONFIGURATION [space] value]`. More information about configuration options, just visit [here](http://gmt.soest.hawaii.edu/doc/latest/gmt.conf.html)

## Set a Initial Variable

To plot a map of an area, we have to know a coordinate of an area, there are minimum longitude, maximum longitude, minimum latitude and maximum latitude. In this example, I use a coordinate of Aceh area that assign the coordinate to `region` variable as follows

```
# Set a coordinate
# region=min longitude/max longitude/min latitude/max latitude
set region=95/97/4/6

# Set output file in postscript format (.ps)
set output=Aceh.ps
```

to write a variable, we just use `set` command and following variable name. Next, we set an output variable to save a result. I write `Aceh.ps` as output file name in postscript format.

## PSBASEMAP

The first layer to create a map is frame map. To create a this, we use `psbasemap` command as follows

```
# Generate base map
gmt psbasemap -JM10/10 -R$region -Xc -Yc -Ba0.5f0.1 -BWSne+tAceh -K > $output
```

|Attribute|Information|
|--|--|
| -J[Projection][scale] | -J indicates to the projection map. There are two options of projection, Mercator (M) and Cartesian (X). The scale = X-scale/Y-scale |
| -R[coordinate] | -R indicates to the coordinate that we use to create map. The coordinate format is min longitude/max longitude/min latitdue/max latitude |
| -X[offset length/align] | -X indicates to the offset length in x-axis. You can adjust by its value or align format (c = center, a = shift the origin back to the original position after plotting, f = shift the origin relative to the fixed lower left, r = move the origin relative to its current location) |
| -Y[offset length/align] | -Y indicates to the offset length in y-axis. You can adjust by its value or align format (c = center, a = shift the origin back to the original position after plotting, f = shift the origin relative to the fixed lower left, r = move the origin relative to its current location) |
| -Ba[major step]f[minor step] | -B map boundary and axes attributes. The `a` is for major step and `f` is for minor step |
| -B[axes]+t[title] | -B map boundary and axes attributes. The `axes` is for coordinate position of W (west)|S (south)|N (north)|E (east). Use capitalize alphabet to activate the its position. The `+t` is for map titile |
| -K | -K indicates to append all attributes to the output. **_Note: The -K is always written at the first layer and the middle layer of map_** |
| > | To store all attributes from the left side to the output varibale that on the right side |

## Plot Grid Image (GRDIMAGE)

We create a good map by adding it with grid image either topography or bathymetry. In this case, We use topography file that has been downloaded from http://dwtkns.com/srtm/ as GeoTiff, then merged an dconverted to `grd` format. First, we have to set where the path of grid image file, gradient image file and color image file are and assign these files to each variable name as follows 

```
# Plot grid image
set grid=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrid.grd
set grad=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrad.grad 
set cpt=/mnt/d/GMT/GMTCODE/TUTORIAL/acehcolor.cpt
```

To add the grid image into a map in GMT, type the following command

```
gmt grdimage $grid -I$grad -R -JM -C$cpt -O -K -P >> $output
```

|Attribute|Information|
|--|--|
| $grid | Call the grid file that was assigned to grid variable |
| -I[gradient file] | Call the gradient file that was assigned to grad variable |
| -R | The coordinate attribute. This configuration will following the previous -R at the `psbasemap` that has been configured |
| -JM | The projection attribute. This configuration will following the previous -JM at the `psbasemap` that has been configured |
| -C[color file] | The color attribute. Call the color file that was assigned to `cpt` variable |
| -O | Overlay attribute with the previous layer. **_Note: The -O is always written at the middle layer and the last layer of map_** |
| -K | -K indicates to append all attributes to the output. **_Note: The -K is always written at the first layer and the middle layer of map_** |
| >> | Append the commands to the output |

**_NOTE: IF YOU DON'T HAVE A GRID IMAGE YET, YOU CAN SKIP THIS COMMAND LINE AND GO TO THE NEXT COMMAND LINE BELLOW_**

**_To Download grid image of Aceh area, just click [here](https://drive.google.com/drive/folders/1SChGqgRf0b0fijXV8gAcOZU9V4rn76gf?usp=sharing)_**

## PSCOAST

Next, we plot a coastline of an area by using `pascoast` command as follows

```
# Generate coast line of an area
gmt pscoast -R -JM -Swhite -Df -W0.02 -LjBL+c0+w50k+f+l+o1/1 -TdjTR+w1,,,N+f1+l+o1.2/1.5 -O -K -P >> $output
```

The `pscoast` also provides the attributes to create a map scale with by using -Lj attribute and create wind direction by using -Tdj attribute. 

|Attribute | Information|
|--|--|
| -R | The coordinate attribute. This configuration will following the previous -R at the `psbasemap` that has been configured |
| -JM | The projection attribute. This configuration will following the previous -JM at the `psbasemap` that has been configured |
| -S[color] | Fill a color outside coastline |
| -D[option] | Resolution of data where the options area are f = full, h = high, i = intermediate, l = low, and c = crude |
| -W[size],[color] | Set shoreline color and size. Default color is black |
| -Lj[position]+c[slon]+w[length][unit]+f+l+o[dx/dy] | To create amap scale. j = set position where the options are TR (Top Right), TL (Top Left), BL (Bottom Left) and BR (Bottom Right) <br/><br/> c[slon] or [slon/slong] = to specify scale origin for geographic projections, where the slat is latitude and the slong is longitude. <br/><br/> w = to specify scale length and its unit. The unit options are e=cm, f=feet, M=miles and k=Km <br/><br/> f = Create fancy map scale. The default scale is plain <br/><br/> l = create a label of map scale <br/><br/> o = set the ooffset of map scale in x-direction and y-direction |
| -O | Overlay attribute with the previous layer. **_Note: The -O is always written at the middle layer and the last layer of map_** |
| -K | -K indicates to append all attributes to the output. **_Note: The -K is always written at the first layer and the middle layer of map_** |
| >> | Append the commands to the output |

## PSXY

The `psxy` command is used to plot a single symbol, multiple symbols and line in GMT. In this case, the symbol plot is represented to earthquake coordinate and the line plot is represented to fault line around Aceh area. The sympol plot and line plot by using `psxy` command are written as follows

```
# Plot a multiple symbol
awk -F',' 'NR!=1 {print $3, $2}' earthquake_aceh.csv | gmt psxy -R -JM -Sc0.5  -Wblack -Gred -K -O >> $output
 
# Plot a line
awk -F',' 'NR!=1 {print $2, $3}' aceh_segment_fault.csv | gmt psxy -R -JM -W1,blue -K -O >> $output
```

To plot the symbol or line to a map, we use the logitude (x-axis) and latitude (y-axis). Becasue the symbol and line data are saved in a file as CSV format, we have to read these files by using `awk` command. For example, the file of `earthquake_aceh.csv` has a longitude coordinate at column 3 ($3) and latitude coordinate at column 2 ($2). The file of `aceh_segment_fault.csv` has a longitude coordinate at column 2 ($2) and latitude coordinate at column 3 ($3). The sign of $ is used to call a column and the NR!=1 is to reject the first row of the file. Sometimes, at the first line is column name. The `-F','` is used to read a CSV file format.

|Attribute|Information|
|--|--|
| -R | The coordinate attribute. This configuration will following the previous -R at the `psbasemap` that has been configured |
| -JM | The projection attribute. This configuration will following the previous -JM at the `psbasemap` that has been configured |
| -S[symbol type][size] | Set a type of symbol and its size. There are several symbol types, such as g = octagon, h = hexagon, i = inverted triangle, n = pentagon, r = rectangle, t = triangle, s = square, c = circle, x = cross, y = y-dash, d = diamond  |
| -W[size],[color] | Set outline color and size. Default color is black |
| -G[color] | Set a symbol color. Default is black |
| -O | Overlay attribute with the previous layer. **_Note: The -O is always written at the middle layer and the last layer of map_** |
| -K | -K indicates to append all attributes to the output. **_Note: The -K is always written at the first layer and the middle layer of map_** |
| >> | Append the commands to the output |

## PSTEXT

We can plot a text inside a map by using `pstext` command. For example

```
# author
echo "95.7 4.5 Created by Aulia Khalqillah (2021)" | gmt pstext -R -JM -Bwesn -F+f7,black -K -O >> $output
```

|Attribute|Information|
|--|--|
|-F+f[size],color|Set a font size and its color|

If you have a many texts want to be plotted, it could be done by using `awk` command

```
# author
awk -F',' 'NR!=1 {print $3, $2-0.05, $5}' earthquake_aceh.csv | gmt pstext -R -JM -F+f7 -K -O >> $output 
```

note, the text has to be in a file. The example above, the texts are stored in file `earthquake_aceh.csv` in column of 5 ($5). The $3 and $2 are the coordinate of texts

## PSSCALE

The `psscale` command is used to create a colorbar of a map based its color. We can type the following command to plot a colorbar

```
# Plot Colorbar
gmt psscale -C$cpt -Dx0c/-1.5c+w10c/0.5c+h -Bxa450f+l"Elevation" -By+lm -G0/3000 -K -O >> $output
```

|Attribute|Information
|--|--|
|-C[color file] | Set a color file in CPT format |
|-D[dx/dx]+w[length/width]+[orientation] | Set a position, length, width and orientation of colorbar scale. The unit options are c = centimeter, i = inches, p = pixels. The orientation options are h = horizontal and v = vertical |
| -B[axes]a[major step]f[minor step]+l[label] | -B map boundary and axes attributes. The `axes` indicates where the position of scale value is (x, y or z),  `a` is for major step and `f` is for minor step |
| -G[min scale/max scale] | Set a minimum and maximum colorbar scale value |
| -O | Overlay attribute with the previous layer. **_Note: The -O is always written at the middle layer and the last layer of map_** |
| -K | -K indicates to append all attributes to the output. **_Note: The -K is always written at the first layer and the middle layer of map_** |

## Plot a Inset Map

The inset map is a sub-map that inside a main map. To plot this, we just create by using `pscoast` command as follows 

```
# Plot Inset Map
gmt pscoast -R94/100/2/7 -JM4.0 -B0ewns -X5.9 -Y0.1 -Dh -W0.2 -G224/240/255 -Sgrey -K -O >> $output
```
and type the following command to plot a box inside inset map

```
# Plot square box as area sign
rm box1.dat # remove previous box1.dat
echo 95 4 > box1.dat
echo 97 4 >> box1.dat
echo 97 6 >> box1.dat
echo 95 6 >> box1.dat
echo 95 4 >> box1.dat
gmt psxy box1.dat -R -JM -W0.8,red -O >> $output
```

|Attribute|Information|
|--|--|
| -R | The coordinate attribute. This configuration will following the previous -R at the `psbasemap` that has been configured |
| -JM | The projection attribute. This configuration will following the previous -JM at the `psbasemap` that has been configured |
| -W[size],[color] | Set shoreline color and size. Default color is black |
| -O | Overlay attribute with the previous layer. **_Note: The -O is always written at the middle layer and the last layer of map_** |

## PSCONVERT

The map can be converted to some formats, such as PNG or JPEG by using `psconvert` command. For example, to convert the map to PNG format, we can use the following command

```
# Convert postscript to png format
psconvert $output -A -P -Tg
```

where the `-Tg` is for PNG fromat. You can use other formats from the following options

|Options|Formtas|
|--|--|
| b | BMP |
| e | EPS |
| f | PDF |
| F | Multi PDF |
| j | JPEG |
| g | PNG |
| G | transparent PNG |
| m | PPM |
| s | SVG |
| t | TIFF |

## NOTE

To get information for each layer, you could add the `-V` attribute in each layer like `-K -O -V >> $output`

## SOURCES

1. Grid Image (SRTM) has been downloaded from http://dwtkns.com/srtm/
2. Earthquake data of Aceh area has been download from [USGS Earthquake Catalog](https://earthquake.usgs.gov/earthquakes/search/)
3. Fault line has been generated from grid image








