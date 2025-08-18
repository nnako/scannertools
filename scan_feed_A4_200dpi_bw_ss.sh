#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    pdf_filename=$2
else
    pdf_filename=scan
fi




#
# wait for user to place the document stack
#

read -p "PLEASE PUT PAGES WITH CONTENT FACING UP INTO THE FEEDER" -n1




#
# scan front pages in forward sequence
#

# unfortunately, when using ADF, the current implementation of SCANADF
# mismatches the PNM output in the way that subsequent tools like imagemagick
# cannot identify the necessaty file format. this seems to be the case when
# scanning with a y range of about 295 mm when more than 1 page is scanned.
# when scanning at a slightly lower y range, this effect is not visible anymore.
# so, instead of using the full range of 210x295 mm for a DIN A4 page, here,
# a reduced range of 210x291 mm is used.

scanadf --source=ADF --mode=Lineart --resolution=200 -x 210 -y 291 -o /home/pi/scan_%02d.pnm



#
# convert all scanned pages to PNG and rename files
#

let filecount=1
filenames=`ls ./*.pnm`
for f in $filenames; do

    # create basename
    filename=${f##*/}
    basename=${filename%%.*}
    echo "$f -> scan_$(printf %02d $filecount).png"

    # convert image and remove original file
    convert $f scan_$(printf %02d $filecount).png
    rm $f

    # counters
    let filecount=$filecount+1

done




#
# convert to PDF
#

convert scan_*.png $pdf_filename.pdf
rm scan_*.png

# move into nextcloud
mv $pdf_filename.pdf ~/NEXTCLOUD/_scan/

