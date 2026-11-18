#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
: "${GF_SIMULATOR_UDID:?Run through simulator_pool.py}"
label="${1:-iPhone}"
finish() {
  result=$?
  trap - EXIT
  python3 QA/audit.py > QA/audit-console.json || true
  python3 Tools/delivery.py > QA/delivery-status.log 2>&1 || true
  exit "$result"
}
trap finish EXIT
if [ -f "QA/${label}-ui.log" ] && rg -q "TEST EXECUTE SUCCEEDED|TEST SUCCEEDED" "QA/${label}-ui.log"; then exit 0; fi
xcrun simctl boot "$GF_SIMULATOR_UDID" || true
xcrun simctl bootstatus "$GF_SIMULATOR_UDID" -b
xcrun simctl status_bar "$GF_SIMULATOR_UDID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
while [ ! -f QA/final-build-ready ]; do sleep 2; done
xcodebuild -project MeadowQuill.xcodeproj -scheme MeadowQuill -configuration Debug -destination "id=$GF_SIMULATOR_UDID" -parallel-testing-enabled NO -derivedDataPath Artifacts/Build -resultBundlePath "QA/${label}.xcresult" -jobs 2 CODE_SIGNING_ALLOWED=NO test-without-building > "QA/${label}-ui.log" 2>&1
xcrun simctl launch "$GF_SIMULATOR_UDID" net.meadowquill.coop731 -AppleLanguages '(en)' -AppleLocale en_US
sleep 3
xcrun simctl io "$GF_SIMULATOR_UDID" screenshot "QA/${label}-yard.png"
container="$(xcrun simctl get_app_container "$GF_SIMULATOR_UDID" net.meadowquill.coop731 data)"
cp "$container/Library/Application Support/MeadowQuill/flock-v1.json" "QA/${label}-saved-farm.json"
xcrun simctl terminate "$GF_SIMULATOR_UDID" net.meadowquill.coop731

# Both device families belong to this single foreground QA operation.
# Release the current booted device before leasing the other family via the factory helper.
if [ "${2:-both}" = both ]; then
  if [ "$label" = iPhone ]; then other=iPad; else other=iPhone; fi
  if ! test -f "QA/${other}-ui.log" || ! rg -q "TEST EXECUTE SUCCEEDED|TEST SUCCEEDED" "QA/${other}-ui.log"; then
    xcrun simctl shutdown "$GF_SIMULATOR_UDID"
    factory="$(cd ../../../.. && pwd)"
    template="$(python3 - "$factory" "$other" <<'TEMPLATE'
import sys
sys.path.insert(0,sys.argv[1])
from gf.genesis.simulator_pool import inventory,PREFIX
family=sys.argv[2]
for rows in inventory()['devices'].values():
 for d in rows:
  if PREFIX not in d['name'] and family in d['name'] and 'Duo' not in d['name']:
   print(d['udid']);sys.exit(0)
raise SystemExit('No available template for '+family)
TEMPLATE
)"
    python3 "$factory/gf/genesis/simulator_pool.py" "$template" bash "$PWD/QA/foreground.sh" "$other" single
  fi
fi
