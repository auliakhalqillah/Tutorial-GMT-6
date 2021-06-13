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
gmt psbasemap -JM10/10 -R$region -Xc -Yc -Ba0.5f0.1 -BWesN+tAceh -K > $output
 
# Plot grid image
set grid=/Volumes/DRIVE/GMT/Tutorial-GMT-6/acehgrid.grd
set grad=/Volumes/DRIVE/GMT/Tutorial-GMT-6/acehgrad.grad 
set cpt=/Volumes/DRIVE/GMT/Tutorial-GMT-6/acehcolor.cpt
 
gmt grdimage $grid -I$grad -R -JM -C$cpt -K -O >> $output
 
# Generate coast line of an area
gmt pscoast -R -JM -Swhite -Df -W0.02 -LjBL+c0+w50k+f+l+o1/1 -TdjTR+w1+f1+l,,,N+o1.2/1.5 -K -O >> $output
 
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

echo "Process is complete. The output is" $output "(.png)"
# gs $output
# open Aceh.png
