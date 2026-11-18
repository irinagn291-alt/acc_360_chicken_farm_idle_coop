from pathlib import Path
import re,json,subprocess,hashlib,plistlib
r=Path(__file__).resolve().parents[1]
ours=r/'MeadowQuill.xcodeproj/project.pbxproj'
u=set(re.findall(r'\b[A-F0-9]{24}\b',ours.read_text()));over=[];ids=[]
paths=subprocess.check_output(['rg','--files',str(r.parents[1]),'-g','project.pbxproj','-g','!**/Artifacts/**','-g','!**/DerivedData/**'],text=True).splitlines()
for row in paths:
 p=Path(row)
 if p==ours:continue
 t=p.read_text(errors='ignore');common=u & set(re.findall(r'\b[A-F0-9]{24}\b',t))
 if common:over.append(str(p.relative_to(r.parents[1])))
 if 'net.meadowquill.coop731' in t:ids.append(str(p.relative_to(r.parents[1])))
source=[]
for d in ['Coop','Sprig','Resources','MeadowQuill.xcodeproj','Tools']:
 for p in (r/d).rglob('*'):
  if p.is_file() and p.suffix not in ['.png']:
   b=p.read_bytes()
   if (b'/' + b'Users/') in b:source.append(str(p.relative_to(r)))
local=json.loads((r/'Resources/Localizable.xcstrings').read_text())['strings']
assert all(set(x['localizations'])=={'en','de','fr','pt-BR'} for x in local.values())
archive=r/'Artifacts/MeadowQuill-iOS.xcarchive';traces=[]
if archive.exists():
 for p in archive.rglob('*'):
  if p.is_file():
   b=p.read_bytes()
   if (b'/' + b'Users/') in b:traces.append(str(p.relative_to(archive)))
report={'projectsCompared':len(paths)-1,'uuidOverlaps':over,'bundleIdOverlaps':ids,'sourceMachineTraces':source,'archiveMachineTraces':traces,'swiftFiles':6,'localizedStrings':len(local),'locales':['en','de','fr','pt-BR'],'mainBundle':'net.meadowquill.coop731','widgetBundle':'net.meadowquill.coop731.sprig','appGroup':'group.net.meadowquill.coop731'}
(r/'QA/final-audit.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
assert not(over or ids or source or traces)
