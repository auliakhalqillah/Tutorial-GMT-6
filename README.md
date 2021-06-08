# Tutorial GMT 6

_Note: This tutorial, I write also in my blog [auliakhalqillah.com](https://auliakhalqillah.com/generate-a-simple-map-in-gmt-6/)_

## Introduction

Hi there. In this repository, we are going to learn how to generate a simple map by using GMT 6. Generic Mapping Tools (GMT) is the tool to generate a map or visual graphic based on code line. The GMT is an open-source tool and has been widely used in Earth, Ocean and Planetary fields. This tool can be used in Linux, Windows and Mac OS. For more information about this tool and how to install it to your own system, just visit https://www.generic-mapping-tools.org/download/.

In this case, the code has been tested in Linux system through the shell of csh. If you have not installed the csh yet, type the following command through the terminal

```
sudo apt-get install csh
```

## Plot a Map

<img align="center" width=358 height=400 src="https://auliakhalqillah.com/wp-content/uploads/2021/06/image-22.png">

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
gmt psbasemap -JM10 -R$region -Xc -Yc -Ba0.5f0.25WSne:.'Aceh': -K> $output
 
# Plot grid image
set grid=/mnt/d/GMT/GMTCODE/GMTSCRIPT/TUTORIAL/acehgrid.grd
set grad=/mnt/d/GMT/GMTCODE/GMTSCRIPT/TUTORIAL/acehgrad.grad 
set cpt=/mnt/d/GMT/GMTCODE/GMTSCRIPT/TUTORIAL/acehcolor.cpt
 
gmt grdimage $grid -I$grad -R -JM -C$cpt -K -O -P >> $output
 
# Generate coast line of an area
gmt pscoast -R -JM -S -Df -W0.02 -LjBL+c0+w50k+f+l+o1/1 -TdjTR+w1,,,N+f1+l+o1.2/1.5 -O -K -P >> $output
 
# Plot a multiple symbol
awk -F',' 'NR!=1 {print $3, $2}' earthquake_aceh.csv | gmt psxy -R -JM -K -O -Sc0.5  -Wblack -Gred >> $output
 
# Plot a line
awk -F',' 'NR!=1 {print $2, $3}' aceh_segment_fault.csv | gmt psxy -R -JM -K -O -W1,blue >> $output
 
# Plot Inset Map
gmt pscoast -R94/100/2/7 -JM4.0 -B0ewns -X5.9 -Y0.1 -Dh -W0.2 -K -O -G224/240/255 -Sgrey >> $output
 
# Plot Colorbar
gmt psscale -C$cpt -Dx0c/-1.5c+w10c/0.5c+h -Bxa450f+l"Elevation" -By+lm -G0/3000 -O -K >> $output
 
# Plot square box as area sign
rm box1.dat # remove previous box1.dat
echo 95 4 > box1.dat
echo 97 4 >> box1.dat
echo 97 6 >> box1.dat
echo 95 6 >> box1.dat
echo 95 4 >> box1.dat
gmt psxy -R -JM -O -W0.8,red box1.dat >> $output
     
psconvert $output -A+n -P -Tg
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

