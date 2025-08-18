#
# get user's wish of document name
#

if [[ $# -ge 2 ]]; then
    filename=$2
else
    filename=scan
fi




#
# get user's wish of number of pages
#

if [[ $# -ge 1 ]]; then

    for (( i=1; i<=$1; i++ )); do

        # wait for user to place the document
        read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

        # scan original
        scanimage --mode=Lineart --resolution=200 -x 105 -y 148 >/home/pi/scan_$i.pnm

    done

    # convert to PNG
    convert scan_*.pnm scan_*.png
    rm scan_*.pnm

    # convert to PDF
    convert scan_*.png $filename.pdf
    rm scan_*.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

else

    # scan original
    scanimage --mode=Lineart --resolution=200 -x 105 -y 148 >/home/pi/scan.pnm

    # convert to PNG
    convert scan.pnm scan.png
    rm scan.pnm

    # convert to PDF
    convert scan.png $filename.pdf
    rm scan.png

    # move into nextcloud
    mv $filename.pdf ~/NEXTCLOUD/_scan/

fi
