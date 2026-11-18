from pathlib import Path
import json,zipfile,hashlib,shutil,subprocess
r=Path(__file__).resolve().parents[1]
def status(name):
 p=r/f'QA/{name}-ui.log'
 if not p.exists():return 'waiting for factory simulator pool'
 s=p.read_text(errors='ignore')
 return 'PASS' if '** TEST EXECUTE SUCCEEDED **' in s or '** TEST SUCCEEDED **' in s else ('FAIL' if '** TEST EXECUTE FAILED **' in s or '** TEST FAILED **' in s else 'running')
result={name:status(name) for name in ['iPhone','iPad']}
for name,s in result.items():
 xc=r/f'QA/{name}.xcresult'
 if s in ['PASS','FAIL'] and xc.exists():
  env=None
  subprocess.run(['/Applications/Xcode.app/Contents/Developer/usr/bin/xcresulttool','export','attachments','--path',str(xc),'--output-path',str(r/f'QA/{name}-attachments')],check=True)
  p=subprocess.run(['/Applications/Xcode.app/Contents/Developer/usr/bin/xcresulttool','get','test-results','summary','--path',str(xc)],capture_output=True,text=True)
  (r/f'QA/{name}-summary.json').write_text(p.stdout)
(r/'QA/device-status.json').write_text(json.dumps(result,indent=2))
report=r/'REPORT.md'
if report.exists():
 text=report.read_text().split('\n<!-- DEVICE STATUS -->')[0]
 text+='\n<!-- DEVICE STATUS -->\n## Current device QA status\n\n'+''.join('- '+k+': '+v+'\n' for k,v in result.items())
 report.write_text(text)
source=[]
for d in ['Coop','Sprig','Resources','MeadowQuill.xcodeproj','Metadata','Tools']:
 source.extend(p for p in (r/d).rglob('*') if p.is_file() and 'xcuserdata' not in p.parts)
source += [r/'README.md',r/'.gitignore',r/'QA/Walk.swift',r/'QA/foreground.sh',r/'QA/audit.py']
if (r/'REPORT.md').exists():source.append(r/'REPORT.md')
with zipfile.ZipFile(r/'Artifacts/MeadowQuill-Source.zip','w',compression=zipfile.ZIP_DEFLATED) as z:
 for p in source:z.write(p,p.relative_to(r))
archive=r/'Artifacts/MeadowQuill-iOS.xcarchive'
if archive.exists():
 with zipfile.ZipFile(r/'Artifacts/MeadowQuill-iOS-unsigned.zip','w',compression=zipfile.ZIP_DEFLATED) as z:
  for p in archive.rglob('*'):
   if p.is_file():z.write(p,Path(archive.name)/p.relative_to(archive))
manifest={str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest() for p in source}
for artifact in ['MeadowQuill-Source.zip','MeadowQuill-iOS-unsigned.zip']:
 p=r/'Artifacts'/artifact
 if p.exists():manifest[str(p.relative_to(r))]=hashlib.sha256(p.read_bytes()).hexdigest()
(r/'Artifacts/SHA256.json').write_text(json.dumps(manifest,indent=2))
print(json.dumps(result,indent=2))
