#! /usr/bin/env bash

rm gold.mp/data/com.metapolator/log.yaml
SUBSET="$(cat ./current_subset.txt)"
#rm ./current_subsetcut.txt
#echo $SUBSET | tr -d "_" >> ./current_subsetcut.txt
SUBSETCUT="$(cat ./current_subsetcut.txt)"
SUBGLIF="$(cat ./current_glifname.txt)"

TEMPUFO="temp.ufo";
BASEUFO="base.ufo";


python diff_blackcompressed.py
python diff_blackwide.py
python diff_thinwide.py
python diff_thincompressed.py


cd gold.mp;
rm ../temp.ufo/glyphs/*.glif
rm ../temp.ufo/glyphs/contents.plist

cp ../base.ufo/glyphs/$SUBSET.glif ../temp.ufo/glyphs/ 

cat >> ../temp.ufo/glyphs/contents.plist << EOF
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>$SUBSETCUT</key>
  <string>$SUBSET.glif</string>
</dict>
</plist>
EOF

rm glyphs.skeleton.base/*.glif
rm glyphs.skeleton.base/*.plist

cp ../temp.ufo/glyphs/contents.plist glyphs.skeleton.base
cp ../temp.ufo/glyphs/$SUBSET.glif glyphs.skeleton.base


cd ..

# import base ufo

cd gold.mp;
metapolator import ../$TEMPUFO base;
cd ..

# find and replace Robofont labels as identifiers
python contours.py

# pretty print
find ./gold.mp \( -name "*.glif" -o -name "*.plist" \) -exec sh -c "cat {} | xmllint --format - > {}~; mv {}~ {}" \;

# export test ufo
cd gold.mp;
#rm -r ../ufos/export.ufo;

rm -r ../temp/blackcompressed.ufo;
rm -r ../temp/blackwide.ufo;
rm -r ../temp/thinwide.ufo;
rm -r ../temp/thincompressed.ufo;

metapolator export blackcompressed ../temp/blackcompressed.ufo;
metapolator export blackwide ../temp/blackwide.ufo;
metapolator export thinwide ../temp/thinwide.ufo;
metapolator export thincompressed ../temp/thincompressed.ufo;

rm ../post/blackcompressed.ufo/glyphs/contents.plist
rm ../post/blackwide.ufo/glyphs/contents.plist
rm ../post/thinwide.ufo/glyphs/contents.plist
rm ../post/thincompressed.ufo/glyphs/contents.plist

rm ../pre/blackcompressed.ufo/glyphs/contents.plist
rm ../pre/blackwide.ufo/glyphs/contents.plist
rm ../pre/thinwide.ufo/glyphs/contents.plist
rm ../pre/thincompressed.ufo/glyphs/contents.plist

cp ../temp/blackcompressed.ufo/glyphs/$SUBGLIF.glif ../pre/blackcompressed.ufo/glyphs/
cp ../temp/blackwide.ufo/glyphs/$SUBGLIF.glif ../pre/blackwide.ufo/glyphs/
cp ../temp/thinwide.ufo/glyphs/$SUBGLIF.glif ../pre/thinwide.ufo/glyphs/
cp ../temp/thincompressed.ufo/glyphs/$SUBGLIF.glif ../pre/thincompressed.ufo/glyphs/

cp ../temp/blackcompressed.ufo/glyphs/$SUBGLIF.glif ../post/blackcompressed.ufo/glyphs/
cp ../temp/blackwide.ufo/glyphs/$SUBGLIF.glif ../post/blackwide.ufo/glyphs/
cp ../temp/thinwide.ufo/glyphs/$SUBGLIF.glif ../post/thinwide.ufo/glyphs/
cp ../temp/thincompressed.ufo/glyphs/$SUBGLIF.glif ../post/thincompressed.ufo/glyphs/

# cd ..

# python diff_blackcompressed.py
# python diff_blackwide.py
# python diff_thinwide.py
# python diff_thincompressed.py

# cd gold.mp;


cp ../pre/blackcompressed.ufo/glyphs/*.glif ../post/blackcompressed.ufo/glyphs/
cp ../pre/blackwide.ufo/glyphs/*.glif ../post/blackwide.ufo/glyphs/
cp ../pre/thinwide.ufo/glyphs/*.glif ../post/thinwide.ufo/glyphs/
cp ../pre/thincompressed.ufo/glyphs/*.glif ../post/thincompressed.ufo/glyphs/

cd ..

python merge_blackcompressed.py
python merge_blackwide.py
python merge_thinwide.py
python merge_thincompressed.py