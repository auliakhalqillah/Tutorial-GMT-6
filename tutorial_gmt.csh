#!/bin/csh
 
# GMT set/configuration
gmt set MAP_FRAME_TYPE plain
gmt set PS_MEDIA 500x500
gmt set FONT_TITLE 12p
 
# Set a coordinate
# region=min longitude/max longitude/min latitude/max latitude
set region=95/97/4/6
 
# Set output file in postscript format (.ps)
set output=Aceh.ps


# Plot vulcanor in legend
echo 95.0,4 | gmt psxy -R -JM -Skvolcano/1.0 -W0.5 -Ggreen -K -O >> $output

# Generate base map
gmt psbasemap -JM10/10 -R$region -Xc -Yc -Ba0.5f0.1 -BWNes+tAceh -V -K > $output
 
# Plot grid image
set grid=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrid.grd
set grad=/mnt/d/GMT/GMTCODE/TUTORIAL/acehgrad.grad 
set cpt=/mnt/d/GMT/GMTCODE/TUTORIAL/acehcolor.cpt
 
gmt grdimage $grid -I$grad -R -JM -C$cpt -K -O >> $output

# Generate coast line of an area
gmt pscoast -R -JM -Swhite -Df -W0.02 -K -O >> $output

# Create magnetic rose (wind driection)
gmt psbasemap -JM -R -Ba0.5f0.1 -Bwesn -TdjTR+w1c+f1+l+o1/1 -K -O >> $output

# Create scale bar
gmt psbasemap -JM -R -Ba0.5f0.1 -Bwesn -LjBL+c0+w50k+f+l+o1/1 -K -O >> $output
 
# Create color for earthquake based on its magnitude
gmt makecpt -Chot -I -T1/9/1 -Z -Df > eqcolor.cpt

# $3 = longitude, $2 = latitude, $5 = magnitude
awk -F',' 'NR!=1 {print $3, $2, $5}' earthquake_aceh.csv | gmt psxy -R -JM -Sc0.25 -W0.3,black -Ceqcolor.cpt -K -O >> $output

# Plot Vulcano
echo 95.65831891600568,5.443900088370068 | gmt psxy -R -JM -Skvolcano/1.0 -W0.5 -Ggreen -K -O >> $output
 
# Plot a line
awk -F',' 'NR!=1 {print $2, $3}' aceh_segment_fault.csv | gmt psxy -R -JM -W1,blue -K -O >> $output

# author
# awk -F',' 'NR!=1 {print $3, $2-0.05, $5}' earthquake_aceh.csv | gmt pstext -R -JM -F+f14 -V -K -O >> $output 
echo "95.7 4.5 Created by Aulia Khalqillah (2022)" | gmt pstext -R -JM -Bwesn -F+f7,black -K -O >> $output

# LEGEND
# Plot Colorbar for topo
gmt psscale -C$cpt -Dx0c/-1.5c+w5c/0.5c+h -Bxa1000f+l"Elevation" -By+lm -G0/3000 -K -O >> $output
# Plot colorbar for earthquake
gmt psscale -Ceqcolor.cpt -Dx6c/-1.5c+w4c/0.5c+h -Bxa1f5+l"Magnitude" -G0/9 -K -O >> $output

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

echo "Process is complete. The output is" $output "(.png)"
# gs $output
# open Aceh.png
