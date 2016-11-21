#!/usr/bin/env bash

set -e
rm -rf ~/.m2/repository/com/example/
ROOT=`pwd`

cat <<'EOF'
 .----------------.  .----------------.  .----------------.  .----------------.  .-----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| | ____    ____ | || |      __      | || | ____   ____  | || |  _________   | || | ____  _____  | |
| ||_   \  /   _|| || |     /  \     | || ||_  _| |_  _| | || | |_   ___  |  | || ||_   \|_   _| | |
| |  |   \/   |  | || |    / /\ \    | || |  \ \   / /   | || |   | |_  \_|  | || |  |   \ | |   | |
| |  | |\  /| |  | || |   / ____ \   | || |   \ \ / /    | || |   |  _|  _   | || |  | |\ \| |   | |
| | _| |_\/_| |_ | || | _/ /    \ \_ | || |    \ ' /     | || |  _| |___/ |  | || | _| |_\   |_  | |
| ||_____||_____|| || ||____|  |____|| || |     \_/      | || | |_________|  | || ||_____|\____| | |
| |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
EOF

echo -e "\n\nInstalling common\n\n"
cd ${ROOT}/common
./mvnw clean install
cd ${ROOT}

echo -e "\n\nBuilding everything\n\n"
./mvnw clean install -Ptest


cat <<'EOF'
 .----------------.  .----------------.  .-----------------. .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| | ____    ____ | || |      __      | || | ____  _____  | || | _____  _____ | || |      __      | || |   _____      | |
| ||_   \  /   _|| || |     /  \     | || ||_   \|_   _| | || ||_   _||_   _|| || |     /  \     | || |  |_   _|     | |
| |  |   \/   |  | || |    / /\ \    | || |  |   \ | |   | || |  | |    | |  | || |    / /\ \    | || |    | |       | |
| |  | |\  /| |  | || |   / ____ \   | || |  | |\ \| |   | || |  | '    ' |  | || |   / ____ \   | || |    | |   _   | |
| | _| |_\/_| |_ | || | _/ /    \ \_ | || | _| |_\   |_  | || |   \ `--' /   | || | _/ /    \ \_ | || |   _| |__/ |  | |
| ||_____||_____|| || ||____|  |____|| || ||_____|\____| | || |    `.__.'    | || ||____|  |____|| || |  |________|  | |
| |              | || |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
EOF

echo -e "\n\nBuilding beer_contracts\n\n"
cd "${ROOT}/beer_contracts"

echo -e "\n\nBuilding only the subset of contracts\n\n"
cd "${ROOT}/beer_contracts/src/main/resources/contracts/com/example/beer-api-producer-external"
cp "${ROOT}/mvnw" .
cp -r "${ROOT}/.mvn" .
./mvnw clean install -DskipTests

rm -rf ~/.m2/repository/com/example/


cat <<'EOF'
 .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| |    ______    | || |  _______     | || |      __      | || |  ________    | || |   _____      | || |  _________   | |
| |  .' ___  |   | || | |_   __ \    | || |     /  \     | || | |_   ___ `.  | || |  |_   _|     | || | |_   ___  |  | |
| | / .'   \_|   | || |   | |__) |   | || |    / /\ \    | || |   | |   `. \ | || |    | |       | || |   | |_  \_|  | |
| | | |    ____  | || |   |  __ /    | || |   / ____ \   | || |   | |    | | | || |    | |   _   | || |   |  _|  _   | |
| | \ `.___]  _| | || |  _| |  \ \_  | || | _/ /    \ \_ | || |  _| |___.' / | || |   _| |__/ |  | || |  _| |___/ |  | |
| |  `._____.'   | || | |____| |___| | || ||____|  |____|| || | |________.'  | || |  |________|  | || | |_________|  | |
| |              | || |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
EOF

rm -rf ~/.m2/repository/com/example/

function build() {
    local folder="${1}"
    echo -e "\n\nBuilding ${folder}\n\n"
    cd "${ROOT}/${folder}"
    ./gradlew clean build publishToMavenLocal
    cd "${ROOT}"
}

echo -e "\n\nBuilding the external contracts jar\n\n"
cd "${ROOT}/beer_contracts"
./mvnw clean install

build common
build producer
build producer_with_external_contracts
build producer_with_restdocs
build consumer
build consumer_with_restdocs