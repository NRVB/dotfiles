#!/usr/local/bin/bash
###############################################################################
# Script for setting default apps to open file extensions with
# This script needs to be runned after the brew.sh script
###############################################################################

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Ensure Homebrew is installed
if ! command_exists brew; then
    echo "Homebrew is not installed. Please install Homebrew before running this script."
    exit 1
fi

# Check if duti is installed; if not, install it
if ! command_exists duti; then
    echo "duti is not installed. Installing duti using Homebrew..."
    brew install duti
    if ! command_exists duti; then
        echo "Failed to install duti. Please install it manually and rerun the script."
        exit 1
    fi
else
    echo "duti is already installed."
fi

# Retrieve bundle identifiers
ZED_BUNDLE_ID=$(osascript -e 'id of app "Zed"')
KEKA_BUNDLE_ID=$(osascript -e 'id of app "Keka"')
IINA_BUNDLE_ID=$(osascript -e 'id of app "IINA"')

# Check if applications are installed
for app in Zed Keka IINA; do
app_uppercase=$(echo "$app" | tr '[:lower:]' '[:upper:]')
BUNDLE_ID_VAR="${app_uppercase}_BUNDLE_ID"
BUNDLE_ID=${!BUNDLE_ID_VAR}

    if [ -z "$BUNDLE_ID" ]; then
        echo "$app is not installed. Please install it and run this script again."
        exit 1
    fi
done

# Create duti configuration
cat <<EOF > default_apps.duti
# Zed associations
public.plain-text $ZED_BUNDLE_ID
public.text $ZED_BUNDLE_ID
public.source-code $ZED_BUNDLE_ID
public.data $ZED_BUNDLE_ID
net.daringfireball.markdown $ZED_BUNDLE_ID
py $ZED_BUNDLE_ID
js $ZED_BUNDLE_ID
css $ZED_BUNDLE_ID
json $ZED_BUNDLE_ID
jsonc $ZED_BUNDLE_ID
xml $ZED_BUNDLE_ID
yml $ZED_BUNDLE_ID
yaml $ZED_BUNDLE_ID
sh $ZED_BUNDLE_ID
bash $ZED_BUNDLE_ID
zsh $ZED_BUNDLE_ID
c $ZED_BUNDLE_ID
cpp $ZED_BUNDLE_ID
h $ZED_BUNDLE_ID
hpp $ZED_BUNDLE_ID
m $ZED_BUNDLE_ID
mm $ZED_BUNDLE_ID
toml $ZED_BUNDLE_ID
ini $ZED_BUNDLE_ID
conf $ZED_BUNDLE_ID
log $ZED_BUNDLE_ID
rb $ZED_BUNDLE_ID
erb $ZED_BUNDLE_ID
go $ZED_BUNDLE_ID
java $ZED_BUNDLE_ID
cs $ZED_BUNDLE_ID
swift $ZED_BUNDLE_ID
kt $ZED_BUNDLE_ID
kts $ZED_BUNDLE_ID
r $ZED_BUNDLE_ID
R $ZED_BUNDLE_ID
pl $ZED_BUNDLE_ID
pm $ZED_BUNDLE_ID
t $ZED_BUNDLE_ID
scala $ZED_BUNDLE_ID
rs $ZED_BUNDLE_ID
lua $ZED_BUNDLE_ID
sql $ZED_BUNDLE_ID
ts $ZED_BUNDLE_ID
tsx $ZED_BUNDLE_ID
coffee $ZED_BUNDLE_ID
litcoffee $ZED_BUNDLE_ID
dart $ZED_BUNDLE_ID
hs $ZED_BUNDLE_ID
lisp $ZED_BUNDLE_ID
cl $ZED_BUNDLE_ID
el $ZED_BUNDLE_ID
Dockerfile $ZED_BUNDLE_ID
.env $ZED_BUNDLE_ID
Makefile $ZED_BUNDLE_ID
makefile $ZED_BUNDLE_ID
GNUmakefile $ZED_BUNDLE_ID

# Keka associations
public.archive $KEKA_BUNDLE_ID
public.zip-archive $KEKA_BUNDLE_ID
public.tar-archive $KEKA_BUNDLE_ID
public.bzip2-archive $KEKA_BUNDLE_ID
7z $KEKA_BUNDLE_ID
rar $KEKA_BUNDLE_ID
xz $KEKA_BUNDLE_ID
cab $KEKA_BUNDLE_ID
iso $KEKA_BUNDLE_ID
tgz $KEKA_BUNDLE_ID
tbz2 $KEKA_BUNDLE_ID
txz $KEKA_BUNDLE_ID
lzh $KEKA_BUNDLE_ID
lha $KEKA_BUNDLE_ID
sit $KEKA_BUNDLE_ID
sitx $KEKA_BUNDLE_ID
br $KEKA_BUNDLE_ID
zst $KEKA_BUNDLE_ID
arj $KEKA_BUNDLE_ID
ace $KEKA_BUNDLE_ID
vhd $KEKA_BUNDLE_ID
vhdx $KEKA_BUNDLE_ID

# IINA associations
public.movie $IINA_BUNDLE_ID
public.audio $IINA_BUNDLE_ID
mp4 $IINA_BUNDLE_ID
mkv $IINA_BUNDLE_ID
avi $IINA_BUNDLE_ID
mov $IINA_BUNDLE_ID
mp3 $IINA_BUNDLE_ID
wav $IINA_BUNDLE_ID
flac $IINA_BUNDLE_ID
webm $IINA_BUNDLE_ID
ogv $IINA_BUNDLE_ID
m4v $IINA_BUNDLE_ID
3gp $IINA_BUNDLE_ID
3g2 $IINA_BUNDLE_ID
ts $IINA_BUNDLE_ID
rm $IINA_BUNDLE_ID
rmvb $IINA_BUNDLE_ID
vob $IINA_BUNDLE_ID
mk3d $IINA_BUNDLE_ID
mpls $IINA_BUNDLE_ID
f4v $IINA_BUNDLE_ID
asf $IINA_BUNDLE_ID
wmv $IINA_BUNDLE_ID
m2ts $IINA_BUNDLE_ID
mts $IINA_BUNDLE_ID
flv $IINA_BUNDLE_ID
divx $IINA_BUNDLE_ID
dv $IINA_BUNDLE_ID
aac $IINA_BUNDLE_ID
wma $IINA_BUNDLE_ID
ogg $IINA_BUNDLE_ID
m4a $IINA_BUNDLE_ID
alac $IINA_BUNDLE_ID
dsd $IINA_BUNDLE_ID
aiff $IINA_BUNDLE_ID
aif $IINA_BUNDLE_ID
caf $IINA_BUNDLE_ID
ape $IINA_BUNDLE_ID
spx $IINA_BUNDLE_ID
opus $IINA_BUNDLE_ID
dsf $IINA_BUNDLE_ID
iff $IINA_BUNDLE_ID

# Optional: Subtitle associations
srt $IINA_BUNDLE_ID
ass $IINA_BUNDLE_ID
ssa $IINA_BUNDLE_ID
sub $IINA_BUNDLE_ID
idx $IINA_BUNDLE_ID
EOF

echo "Applying default application settings..."
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue

    UTI_OR_EXT=$(echo "$line" | awk '{print $1}')
    BUNDLE_ID=$(echo "$line" | awk '{print $2}')

    echo "Setting '$UTI_OR_EXT' to use '$BUNDLE_ID'"
    duti -s "$BUNDLE_ID" "$UTI_OR_EXT" all
done < default_apps.duti

rm default_apps.duti

echo "Refreshing Launch Services..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user


echo "Restarting Finder..."
killall Finder

echo "Default applications set successfully."
